variable "vpc_id" {}
variable "ami_id" {
  default = "ami-333f2203"
}
variable "instance_type" {
  default = "t2.medium"
}
variable "key_name" {}
variable "subnet_id" {}
variable "additional_user_data" {
  default = ""
}
variable "github_client" {}
variable "github_secret" {}
variable "github_org" {}
variable "workers" {
  default = "unix:///var/run/docker.sock,unix:///var/run/docker.sock"
}
variable "availability_zone" {}
variable "ebs_size" {
  default = 10
}
variable "image" {
  default = "drone/drone:latest"
}
