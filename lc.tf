# ---------------------------------------
# Launch Config
# ---------------------------------------
resource "aws_launch_configuration" "proxy" {
  name_prefix          = "terraform-proxy-lc-"
  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.proxy_instance_profile.name}"
  security_groups      = ["${aws_security_group.ec2_sg.id}"]
  enable_monitoring    = "${var.enable_monitoring}"
  user_data            = "${data.template_file.user_data.rendered}"

  # Setup root block device
  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }

  # Create before destroy
  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------
# Render Bastion userdata bootstrap file
# ---------------------------------------
data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    hostname                = "${var.hostname}"
    dns_domain_name         = "${var.dns_domain_name}"
    hosted_zone_id          = "${var.hosted_zone_id}"
    supplementary_user_data = "${var.supplementary_user_data}"
    aws_region              = "${var.aws_region}"
    vpc_cidr                = "${var.vpc_cidr}"
  }
}
