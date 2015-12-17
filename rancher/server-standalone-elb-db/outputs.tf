output "loadbalancer_dns_name" {
  value = "${aws_elb.loadbalancer.dns_name}"
}

output "loadbalancer_hosted_zone_id" {
  value = "${aws_elb.loadbalancer.hosted_zone_id}"
}

output "server_dns" {
  value = "${aws_instance.server.public_dns}"
}

output "sg_rancher_transport_id" {
  value = "${aws_security_group.transport.id}"
}
