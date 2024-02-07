output "instance_id" {
  value       = openstack_compute_instance_v2.instance.id
  description = "The ID of the instance"
}

output "instance_name" {
  value       = openstack_compute_instance_v2.instance.name
  description = "The name of the instance"
}

output "instance_ip" {
  value       = openstack_compute_instance_v2.instance.access_ip_v4
  description = "The IP address of the instance"
}

output "instance_floating_ip" {
  value       = openstack_networking_floatingip_v2.floating_ip.address
  description = "The floating IP address of the instance"
}

