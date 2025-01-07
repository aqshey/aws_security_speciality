// create nlb



resource "aws_lb" "nlb" {
  name               = "my-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [var.subnet_id]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  enable_http2 = true
  tags = {
    Name = "my-nlb"
  }
}
