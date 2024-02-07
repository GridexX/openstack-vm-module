variable "image_name" {
  type        = string
  description = "The name of the image to use for the instance"
}

variable "flavor_name" {
  type        = string
  description = "The flavor to use for the instance"
}

variable "public_key_pair_path" {
  type        = string
  description = "Path to the SSH public key pair to use for accesing the instance"
  default     = "~/.ssh/id_rsa.pub"
}

variable "public_network_name" {
  type        = string
  description = "The name of the public network to use for the instance"
  default     = "public"
}

variable "create_random_suffix" {
  description = "Add random suffix to instance name"
  type        = bool
  default     = false
}

variable "instance_name" {
  type        = string
  description = "The name of the instance"
}

variable "ssh_user" {
  type = string
  description = "The user used for SSHing into the instance"
}

variable "dns_nameservers" {
  type        = list(string)
  description = "The list of DNS nameservers to use for the instance"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "user_data" {
  type        = string
  description = "The user data to use for the instance. Can be inline, read in from the file function, or the template_cloudinit_config resource"
  default     = null
}