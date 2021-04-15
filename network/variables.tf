variable "vpc_cidr" {
  description = "Value of the vpc cidr"
  type        = string
  default     = "10.2.0.0/16"
}

variable "vpc_name" {
  description = "Value of the vpc name"
  type        = string
  default     = "eks_vpc"
}

variable "cidr_block_igw" {
  description = "Value of the igw cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "eks_cluster_name" {
  description = "Value of the eks cluster"
  type        = string
  default     = "eks_cluster"
}


