resource "template_file" "user_data" {
  filename = "${path.module}/user_data.tpl"
  vars {
    drone_command = "${var.drone_command}"
    github_client = "${var.github_client}"
    github_secret = "${var.github_secret}"
    github_org = "${var.github_org}"
    db_driver = "${var.db_driver}"
    db_config = "${var.db_config}"
    workers = "${var.workers}"
    image = "${var.image}"
    additional_user_data = "${var.additional_user_data}"
  }
}

resource "aws_security_group" "drone" {
  name = "drone_server"
  description = "Security rules for Drone server"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "drone" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.drone.id}"
  ]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  user_data = "${template_file.user_data.rendered}"
  tags {
    Name = "drone"
  }
}
