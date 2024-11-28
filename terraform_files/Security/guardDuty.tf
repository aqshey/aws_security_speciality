terraform {
required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.0"
      }
  }
  required_version = "0.15"
}
provider "aws" { region = "eu-central-1" }

data "aws_guardduty_detector" "security_detector" { provider = aws.security }
data "aws_s3_bucket" "guardduty_findings" { bucket = "guardduty-findings-bucket" }
data "aws_caller_identity" "master_account" { provider = aws.security }
resource "aws_guardduty_detector" "security" {
  provider = aws.security
  enable   = true
}

resource "aws_guardduty_member" "member1" {
  provider       = aws.security
  account_id     = "111111111111"
  email          = "member1@example.com"
  invite         = true
  invite_message = "Please accept the GuardDuty invitation."
  detector_id    = aws_guardduty_detector.security.id
}

resource "aws_guardduty_member" "member2" {
  provider       = aws.security
  account_id     = "222222222222"
  email          = "member2@example.com"
  invite         = true
  invite_message = "Please accept the GuardDuty invitation."
  detector_id    = aws_guardduty_detector.security.id
}

# Accept Invitations in Member Accounts
resource "aws_guardduty_invite_accepter" "member1" {
  provider          = aws.member1
  detector_id       = aws_guardduty_detector.security.id
  master_id         = "master-account-id"
  master_account_id = ""
}

resource "aws_guardduty_invite_accepter" "member2" {
  provider          = aws.member2
  detector_id       = aws_guardduty_detector.security.id
  master_id         = "master-account-id"
  master_account_id = ""
}

# Findings Publishing Configuration
resource "aws_s3_bucket" "guardduty_findings" {
  bucket = "guardduty-findings-bucket"
}

resource "aws_guardduty_publishing_destination" "findings" {
  provider         = aws.security
  detector_id      = aws_guardduty_detector.security.id
  destination_arn  = aws_s3_bucket.guardduty_findings.arn
  destination_type = "S3"
  kms_key_arn      = ""
}

# IAM Role for GuardDuty to Publish Findings to S3
resource "aws_iam_role" "guardduty_s3_publish" {
  name = "GuardDutyS3Publish"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name = "GuardDutyS3PublishPolicy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:PutObject",
            "s3:PutObjectAcl"
          ]
          Resource = "${aws_s3_bucket.guardduty_findings.arn}/*"
        }
      ]
    })
  }
}
