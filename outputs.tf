#
# Define outputs
#

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = "${aws_autoscaling_group.proxy.name}"
}
