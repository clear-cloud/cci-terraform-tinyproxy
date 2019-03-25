variable "aws_region" {}
variable "vpc_id" {}
variable "contact" {}
variable "vpc_cidr" {
  description = "CIDR block of the VPC which will be granted access to the Proxy"
}
  
variable "dns_domain_name" {
  description = "DNS domain name the host will be part of. eg dev.domain.io"
}

variable "health_check_grace_period" {
  description = "Health check Grace period for ASG"
  default     = "120"
}

variable "health_check_type" {
  default = "EC2"
}

variable "hostname" {
  default = "proxy"
}

variable "hostname_offset" {
  default = "0"
}

variable "hosted_zone_id" {
  description = "Variable for Hosted zone id, eg Z2XXOVXYYGMD12"
}

variable "environment" {
  description = "The environment the Proxy will be part of, eg, DEV, UAT or PROD"
}

variable "proxy_access_port" {
  description = "Port used to connect to proxy server"
  default     = "8888"
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
}

variable "supplementary_user_data" {
  description = "Supplementary shell script commands for adding to user data."
  default     = ""
}

variable "key_name" {
  description = "Initial Key used to build the host"
}

variable "enable_monitoring" {
  description = "Enables / disables detailed monitoring"
  default     = "false"
}

variable "instance_type" {
  description = "ec2 instance type"
  default     = "t3.micro"
}

variable "image_id" {
  description = "AMI to use"
}

variable "volume_type" {
  description = "ec2 volume type"
  default     = "gp2"
}

variable "orchestration" {
  description = "Link to orchestration used for the build, eg link to git repository"
}

variable "max_size" {
  description = "ASG maximum size"
  default     = "1"
}

variable "min_size" {
  description = "ASG minimum size"
  default     = "1"
}

variable "desired_capacity" {
  description = "ASG desired size"
  default     = "1"
}

variable "volume_size" {
  description = "ec2 Volume size"
  default     = "30"
}
