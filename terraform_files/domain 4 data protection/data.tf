data "aws_cloudhsm_v2_clusters" "cloudhsm" {
  cluster_id = "cloudhsm-cluster"
}

data "aws_availability_zones" "available" {
  state = "available"
}