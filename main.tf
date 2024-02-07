#######################
#    SECURITY GROUPS  #
#######################

#######################
#         SSH         #
#######################
resource "openstack_networking_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "Allow SSH from anywhere - Recommended to delete after deployment"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.ssh.id
}

#######################
#         HTTP        #
#######################
resource "openstack_networking_secgroup_v2" "http" {
  name        = "http"
  description = "Allow HTTP/HTTPS from anywhere"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.http.id
}

resource "random_pet" "suffix" {
  length = 1
}

locals {
  random_name = var.create_random_suffix ? "${var.instance_name}-${random_pet.suffix.id}" : var.instance_name
}


#######################
#        NETWORK      #
#######################


data "openstack_networking_network_v2" "public_net" {
  name = var.public_network_name
}

resource "openstack_networking_network_v2" "private_net" {
  name           = "${local.random_name}-private-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "${local.random_name}--private-subnet"
  network_id      = openstack_networking_network_v2.private_net.id
  cidr            = "192.168.10.0/24"
  dns_nameservers = var.dns_nameservers
}

resource "openstack_networking_router_v2" "router" {
  name                = "${local.random_name}-router"
  external_network_id = data.openstack_networking_network_v2.public_net.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

#######################
#        SSH KEY      #
#######################
resource "openstack_compute_keypair_v2" "key_pair" {
  name       = "${local.random_name}-key-pair"
  public_key = file(var.public_key_pair_path)
}

#######################
#        INSTANCE     #
#######################
resource "openstack_compute_instance_v2" "instance" {
  name        = local.random_name
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.key_pair.name
  security_groups = [
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.http.name,
  ]

  user_data = var.user_data != null ? var.user_data : null

  network {
    uuid = openstack_networking_network_v2.private_net.id
  }

}


resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = var.public_network_name
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.instance.id
}
