variable "fargate_profile_name" {
  description = "Value of the fargate profile"
  type        = string
  default     = "my_fargate_profile"
}

variable "eks_cluster_name" {
  description = "Value of the eks cluster"
  type        = string
  default     = "eks_cluster"
}

variable "cidr_block_igw" {
  description = "Value of the igw cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_subnets" {
    description = "List of all the Private Subnets"
}

