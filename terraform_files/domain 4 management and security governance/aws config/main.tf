// configure aws config

provider "aws" {
  region = var.region
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "default"
  role_arn = "arn:aws:iam::${var.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
}

resource "aws_config_delivery_channel" "delivery_channel" {
  name           = "default"
  s3_bucket_name = "my-bucket"
  sns_topic_arn  = "arn:aws:sns:us-east-1:123456789012:my-topic"
}

resource "aws_config_configuration_recorder_status" "config_recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

resource "aws_config_organization_custom_rule" "organization_custom_rule" {
  name                = "my-organization-custom-rule"
  lambda_function_arn = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
  trigger_types = ["ConfigurationItemChangeNotification", "OversizedConfigurationItemChangeNotification"]
}

resource "aws_config_organization_managed_rule" "organization_managed_rule" {
  name            = "my-organization-managed-rule"
  rule_identifier = "AWS_ACCESS_KEYS_ROTATED"
}
