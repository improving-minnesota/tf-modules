output "public_dns" {
  value = "${aws_instance.sonar.public_dns}"
}
