// configure waf for alb
resource "aws_wafregional_web_acl" "waf" {
  name        = "waf"
  metric_name = "waf"

  default_action {
    type = "ALLOW"
  }

rule {
  rule_id = "allow_header_rule"
    priority    = 1
    action {
      type = "ALLOW"
    }
    override_action {
      type = "NONE"
    }
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
    cidr_blocks = ["10.0.0.0/16"]
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
  cidr_block     = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "example2" {
  vpc_id            = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
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