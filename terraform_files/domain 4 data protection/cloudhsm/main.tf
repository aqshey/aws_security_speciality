// create cloudhsm cluster

provider "aws" {
  region = "eu-central-1"
}

resource "aws_cloudhsm_v2_cluster" "cloudhsm" {
  cluster_id = "cloudhsm-cluster"
  hsm_type   = "hsm1.medium"
  subnet_ids = [aws_subnet.subnet.id]
  tags = {
    Name = "cloudhsm-cluster"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.1/24"
    tags = {
        Name = "cloudhsm-subnet"
    }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.1/16"
    tags = {
        Name = "cloudhsm-vpc"
    }
}
