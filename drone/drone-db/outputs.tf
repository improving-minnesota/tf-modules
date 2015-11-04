output "public_dns" {
  value = "${aws_instance.drone.public_dns}"
}

output "instance_id" {
  value = "${aws_instance.drone.id}"
}
