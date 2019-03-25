# ----------------------------
# Proxy EC2 Instance Profile
# ----------------------------
resource "aws_iam_instance_profile" "proxy_instance_profile" {
  name = "${var.environment}_proxy_instance_profile"
  role = "${aws_iam_role.proxy_role.name}"
}

# ----------------
# Proxy EC2 Role
# ----------------
resource "aws_iam_role" "proxy_role" {
  name = "${var.environment}_proxy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# ---------------------------------
# Attach Proxy Policy to Role
# ---------------------------------
resource "aws_iam_role_policy_attachment" "proxy_attach_ec2_policy" {
  role       = "${aws_iam_role.proxy_role.name}"
  policy_arn = "${aws_iam_policy.proxy_policy.arn}"
}

# ------------------
# Proxy IAM Policy
# ------------------
resource "aws_iam_policy" "proxy_policy" {
  name        = "${var.environment}_proxy_policy"
  path        = "/"
  description = "${var.environment} Proxy IAM Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "r53",
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${var.hosted_zone_id}"
      ]
    },
    {
       "Sid": "s3List",
       "Effect": "Allow",
       "Action": [
           "s3:ListBucketByTags",
           "s3:ListBucket",
           "s3:HeadBucket",
           "s3:ListAllMyBuckets"
       ],
       "Resource":[
          "*"
     ]
     },
     {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
  ]
}
EOF
}
