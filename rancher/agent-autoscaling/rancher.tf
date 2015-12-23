resource "aws_launch_configuration" "rancher" {
  image_id = "${var.host_image_id}"
  instance_type = "${var.host_instance_type}"
  key_name = "${var.host_key_name}"
  iam_instance_profile = "${var.host_profile}"
  security_groups = [
    "${concat([aws_security_group.rancher.id], split(",", var.host_security_group_ids))}"
  ]
  associate_public_ip_address = true
  ebs_optimized = true
  ebs_block_device {
    device_name = "sdf"
    volume_type = "gp2"
    volume_size = "${var.host_root_volume_size}"
    delete_on_termination = true
  }
  user_data = <<EOF
#cloud-config
rancher:
  services:
    rancher:
      image: ${var.rancher_image}
      command: ${var.rancher_server_url}
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
      privileged: true
disk_setup:
  /dev/xvdf:
    table_type: 'mbr'
    layout: true
    overwrite: false
fs_setup:
  - device: '/dev/xvdf'
    filesystem: 'ext4'
    partition: 'auto'
mounts:
  - [ xvdf, /mnt, auto, "defaults" ]
EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher" {
  max_size = "${var.host_capacity_max}"
  min_size = "${var.host_capacity_min}"
  desired_capacity = "${var.host_capacity_desired}"
  launch_configuration = "${aws_launch_configuration.rancher.id}"
  health_check_type = "EC2"
  health_check_grace_period = 300
  load_balancers = [
    "${split(",", var.loadbalancer_ids)}"
  ]
  vpc_zone_identifier = [
    "${split(",", var.host_subnet_ids)}"
  ]
  tag {
    key = "Name"
    value = "rancher_hosts"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "rancher" {
  description = "Allow traffic to rancher instances"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "rancher_upd_500_ingress" {
  type = "ingress"
  from_port = 500
  to_port = 500
  protocol = "udp"
  security_group_id = "${aws_security_group.rancher.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_upd_500_egress" {
  type = "egress"
  from_port = 500
  to_port = 500
  protocol = "udp"
  security_group_id = "${aws_security_group.rancher.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_upd_4500_ingress" {
  type = "ingress"
  from_port = 4500
  to_port = 4500
  protocol = "udp"
  security_group_id = "${aws_security_group.rancher.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_upd_4500_egress" {
  type = "ingress"
  from_port = 4500
  to_port = 4500
  protocol = "udp"
  security_group_id = "${aws_security_group.rancher.id}"
  self = true
}

resource "aws_security_group_rule" "rancher_egress" {
  type = "egress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.rancher.id}"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
