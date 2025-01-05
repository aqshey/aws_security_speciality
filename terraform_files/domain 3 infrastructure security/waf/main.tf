// configure waf for alb
resource "aws_wafregional_web_acl" "waf" {
  name        = "waf"
  metric_name = "waf"

  default_action {
    type = "ALLOW"
  }

  rule {
    rule_id     = "custom_rule_id"
    name        = "rule"
    metric_name = "rule"
    priority    = 1

    action {
      type = "BLOCK"
    }

    override_action {
      type = "NONE"
    }

    statement {
      rule_group_reference_statement {
        arn = "arn:aws:waf::123456789012:rulegroup/1234abcd-12ab-34cd-56ef-123456789012"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rule"
      sampled_requests_enabled   = true
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafregional_web_acl_association" "waf_association" {
  resource_arn = aws_alb.example.arn
  web_acl_id   = aws_wafregional_web_acl.waf.id
}

resource "aws_alb" "example" {
  name               = "example"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example.id]
  subnets            = [aws_subnet.example1.id, aws_subnet.example2.id]

  enable_deletion_protection = false
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "example"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["10.0,0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_subnet" "example1" {
  vpc_id            = aws_vpc.example.id
  cidr_blocks       = ["10.0,0.0/16"]
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "example2" {
  vpc_id            = aws_vpc.example.id
  cidr_blocks       = ["10.0,0.0/16"]
  availability_zone = "us-west-2b"
}

resource "aws_vpc" "example" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "example"
  }


  cidr_block = "10.0.0.0/16"
}