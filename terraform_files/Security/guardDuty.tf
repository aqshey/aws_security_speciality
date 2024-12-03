# Terraform configuration for AWS GuardDuty setup

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
  required_version = "0.15"
}

provider "aws" {
  region = "eu-central-1"
}

# Data source to get the GuardDuty detector
data "aws_guardduty_detector" "security_detector" {
  provider = aws.security
}

# Data source to get the S3 bucket for GuardDuty findings
data "aws_s3_bucket" "guardduty_findings" {
  bucket = "guardduty-findings-bucket"
}

# Data source to get the caller identity of the master account
data "aws_caller_identity" "master_account" {
  provider = aws.security
}

# Resource to create a GuardDuty detector
resource "aws_guardduty_detector" "security" {
  provider = aws.security
  enable   = true
}

# Resource to create a GuardDuty member account
resource "aws_guardduty_member" "member1" {
  provider       = aws.security
  account_id     = "111111111111"
  email          = "member1@example.com"
  invite         = true
  invite_message = "Please accept the GuardDuty invitation."
  detector_id    = aws_guardduty_detector.security.id
}

# Resource to create another GuardDuty member account
resource "aws_guardduty_member" "member2" {
  provider       = aws.security
  account_id     = "222222222222"
  email          = "member2@example.com"
  invite         = true
  invite_message = "Please accept the GuardDuty invitation."
  detector_id    = aws_guardduty_detector.security.id
}

# Resource to accept the GuardDuty invitation for member1
resource "aws_guardduty_invite_accepter" "member1" {
  provider          = aws.member1
  detector_id       = aws_guardduty_detector.security.id
  master_id         = "master-account-id"
  master_account_id = ""
}

# Resource to accept the GuardDuty invitation for member2
resource "aws_guardduty_invite_accepter" "member2" {
  provider          = aws.member2
  detector_id       = aws_guardduty_detector.security.id
  master_id         = "master-account-id"
  master_account_id = ""
}

# Resource to create an S3 buc