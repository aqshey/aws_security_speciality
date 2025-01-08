// create audit manager
provider "aws" {
  region = "eu-central-1"
}

resource "aws_auditmanager_assessment" "assessment" {
  name                    = "my-assessment"
  framework_id            = data.aws_auditmanager_framework.framework.id
  roles {}
}


data "aws_auditmanager_framework" "framework" {
  name = "my-framework"
}

resource "aws_auditmanager_control_set" "control_set" {
  name = "my-control-set"
}

