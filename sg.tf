#
# ec2 access SG
#
resource "aws_security_group" "ec2_sg" {
  name        = "sg.proxy.${var.hostname}${format("%03d", count.index + 1 + var.hostname_offset)}.${var.dns_domain_name}"
  description = "sg.proxy.${var.hostname}${format("%03d", count.index + 1 + var.hostname_offset)}.${var.dns_domain_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.proxy_access_port}"
    to_port     = "${var.proxy_access_port}"
    protocol    = "TCP"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all outbound traffic

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    "environment"   = "${var.environment}"
    "contact"       = "${var.contact}"
    "orchestration" = "${var.orchestration}"
  }
}
