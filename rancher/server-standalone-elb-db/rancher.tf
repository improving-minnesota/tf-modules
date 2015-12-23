resource "aws_security_group" "elb" {
    name = "rancher_load_balancer"
    description = "All inbound traffic to Rancher Load Balancer"

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }
}

resource "aws_security_group" "server" {
  name = "rancher_server"
  description = "All inbound traffic to Rancher server"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.elb.id}"
    ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

}

resource "aws_security_group" "transport" {
  name = "rancher_transport"
  description = "Allow IPSec networking within Rancher cluster"
}

resource "aws_elb" "loadbalancer" {
  security_groups = [
    "${aws_security_group.elb.id}"
  ]
  subnets = [
    "${split(",", var.loadbalancer_subnet_ids)}"
  ]
  instances = [
    "${aws_instance.server.id}"
  ]
  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2

    target = "HTTP:8080/ping"
    interval = 30
    timeout = 10
  }
}

resource "aws_proxy_protocol_policy" "websockets" {
  load_balancer = "${aws_elb.loadbalancer.name}"
  instance_ports = [
    8080
  ]
}

resource "aws_instance" "server" {
  ami = "${var.server_ami}"
  instance_type = "${var.server_instance_type}"
  key_name = "${var.server_key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.server.id}",
    "${aws_security_group.transport.id}"
  ]
  subnet_id = "${var.server_subnet_id}"
  associate_public_ip_address = true
  tags {
    Name = "rancher-server"
  }
  user_data = <<USERDATA
#cloud-config
rancher:
  services:
    rancher:
      image: ${var.rancher_image}
      restart: always
      ports:
        - 8080:8080
      environment:
        - CATTLE_DB_CATTLE_MYSQL_HOST=${var.database_host}
        - CATTLE_DB_CATTLE_MYSQL_PORT=${var.database_port}
        - CATTLE_DB_CATTLE_MYSQL_NAME=${var.database_schema}
        - CATTLE_DB_CATTLE_USERNAME=${var.database_username}
        - CATTLE_DB_CATTLE_PASSWORD=${var.database_password}
USERDATA
}
