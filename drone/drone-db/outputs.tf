output "public_dns" {
  value = "${aws_instance.drone.public_dns}"
}
