// iam:passrole example

provider "aws" {
  region = "eu-central-1"
}
// service role

resource "aws_iam_role" "service_role" {
  name = "my-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudformation.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "service_role_attachment" {
  role       = aws_iam_role.service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

