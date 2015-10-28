resource "template_file" "user_data" {
  filename = "${path.module}/user_data.tpl"
  vars {
    sonar_command = "${var.sonar_command}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    db_url = "${var.db_url}"
    image = "${var.image}"
    additional_user_data = "${var.additional_user_data}"
  }
}

resource "aws_security_group" "sonar" {
  name = "sonar_server"
  description = "Security rules for SonarQube server"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9000
    to_port = 9000
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

resource "aws_ebs_volume" "home" {
  availability_zone = "${var.availability_zone}"
  size = "${var.ebs_size}"
  tags {
    Name = "sonarqube_server_home"
  }
}

resource "aws_instance" "sonar" {
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_security_group.sonar.id}"
  ]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true
  user_data = "${template_file.user_data.rendered}"
  tags {
    Name = "sonarqube"
  }
}

resource "aws_volume_attachment" "sonarqube_home" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.home.id}"
  instance_id = "${aws_instance.sonar.id}"
}
