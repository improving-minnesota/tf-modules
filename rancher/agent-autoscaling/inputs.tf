variable "host_ami" {
  description = "The AMI ID for RancherOS in the region you are launching"
}

variable "host_profile" {
  description = "The IAM profile to assign to the instances"
  default = ""
}

variable "host_key_name" {
  description = "The EC2 KeyPair to use for the machine"
}

variable "vpc_id" {
  description = "The VPC to launch resources in"
}

variable "host_subnet_ids" {
  description = "The subnets to launch the Rancher hosts in"
}

variable "host_security_group_ids" {
  description = "Additional security groups to apply to hosts"
  default = ""
}

variable "host_root_volume_size" {
  description = "The size of the root EBS volume in GB"
  default = 32
}

variable "loadbalancer_ids" {
  description = "The loadbalancers to attach to the ASG"
}

variable "host_instance_type" {
  description = "The instance type for the hosts"
  default = "m4.large"
}

variable "rancher_image" {
  description = "The Docker image to run Rancher from"
  default = "rancher/agent:latest"
}

variable "rancher_server_url" {
  description = "The URL for the Rancher server to join including the environment token"
}

varaible "host_capacity_min" {
  description = "The miminum capacity for the ASG"
  default = 1
}

varaible "host_capacity_max" {
  description = "The maximum capacity for the ASG"
  default = 4
}

varaible "host_capacity_desired" {
  description = "The desired capacity for the ASG"
  default = 1
}
