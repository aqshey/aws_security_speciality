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


// calling all modules inside this


module "cloudhsm" {
  source = "./cloudhsm"
  vpc_id = aws_vpc.main.id
  subnet_id = aws_subnet.subnet.id

  availability_zone = data.aws_availability_zones.available.names[0]
  cluster_id        = data.aws_cloudhsm_v2_clusters.cloudhsm.id
  hsm_type          = "hsm1.medium"
  region            = "eu-central-1"
}

module "kms" {
  source = "./kms"
  vpc_id = aws_vpc.main.id
  subnet_id = aws_subnet.subnet.id

  availability_zone = data.aws_availability_zones.available.names[0]
  cluster_id        = data.aws_cloudhsm_v2_clusters.cloudhsm.id
  hsm_type          = "hsm1.medium"
  region            = "eu-central-1"
}

module "nlb" {
  source = "./nlb"
  vpc_id = aws_vpc.main.id
  subnet_id = aws_subnet.subnet.id

  availability_zone = data.aws_availability_zones.available.names[0]
  cluster_id        = data.aws_cloudhsm_v2_clusters.cloudhsm.id
  hsm_type          = "hsm1.medium"
  region            = "eu-central-1"
}

