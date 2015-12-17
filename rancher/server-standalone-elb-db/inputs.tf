variable "server_ami" {
  description = "The AMI ID for RancherOS in the region you are launching"
}

variable "server_key_name" {
  description = "The EC2 KeyPair to use for the machine"
}

variable "database_host" {
  description = "The hostname for the database"
}

variable "database_port" {
  description = "The port for the database [3306]"
  default = 3306
}

variable "database_schema" {
  description = "The schema for the database [rancher]"
  default = "rancher"
}

variable "database_username" {
  description = "The username for the database [rancher]"
  default = "rancher"
}

variable "database_password" {
  description = "The password for the database"
}

variable "vpc_id" {
  description = "The VPC to launch resources in"
}

variable "server_subnet_id" {
  description = "The subnet to launch the Rancher server in"
}

variable "loadbalancer_subnet_ids" {
  description = "The subnets to launch the ELB in"
}

variable "server_instance_type" {
  description = "The instance type for the server"
  default = "t2.micro"
}

variable "rancher_image" {
  description = "The Docker image to run Rancher from"
  default = "rancher/server:latest"
}
