// create cloudhsm cluster

provider "aws" {
  region = var.region
}

resource "aws_cloudhsm_v2_cluster" "cloudhsm" {
  cluster_id = "cloudhsm-cluster"
  hsm_type   = "hsm1.medium"
  subnet_ids = [var.subnet_id]
  tags = {
    Name = "cloudhsm-cluster"
  }
}

