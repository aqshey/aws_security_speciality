// create kms key


resource "aws_kms_key" "my_kms_key" {
  description             = "My KMS key"
  deletion_window_in_days = 10
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
  tags = {
    Name = "my-kms-key"
    }
}
