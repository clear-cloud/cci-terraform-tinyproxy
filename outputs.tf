#
# Define outputs
#

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = "${aws_autoscaling_group.proxy.name}"
}

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = "${aws_iam_policy.proxy_policy.arn}"
}
