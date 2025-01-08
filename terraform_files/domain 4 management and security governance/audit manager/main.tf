// create audit manager
provider "aws" {
  region = "eu-central-1"
}

resource "aws_auditmanager_assessment" "assessment" {
  name                    = "my-assessment"
  assessment_framework_id = aws_auditmanager_framework.framework.id
  framework_id            = ""
  roles {}
}


data "aws_auditmanager_framework" "framework" {
  name = "my-framework"
}

resource "aws_auditmanager_control_set" "control_set" {
  name = "my-control-set"
}

