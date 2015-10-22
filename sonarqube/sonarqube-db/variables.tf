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
variable "db_username" {
  default = "sonar"
}
variable "db_password" {
  default = "sonar"
}
variable "db_url" {}

variable "availability_zone" {}
variable "ebs_size" {
  default = 2
}
variable "image" {
  default = "library/sonarqube:5.1"
}
