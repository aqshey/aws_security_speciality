// adding required variables

variable "region" {
  description = "The region in which the CloudHSM cluster will be created"
}

variable "subnet_id" {
  description = "The subnet ID in which the CloudHSM cluster will be created"
}

variable "cluster_id" {
  description = "The ID of the CloudHSM cluster"
}

variable "hsm_type" {
  description = "The type of HSM to use in the CloudHSM cluster"
}

variable "availability_zone" {
  description = "The availability zone in which the CloudHSM cluster will be created"
}
