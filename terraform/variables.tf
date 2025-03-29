variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Account region"
}

variable "eks_cluster_name" {
  type        = string
  default     = "fiap-hackathon-eks-cluster"
  description = "EKS Cluster name"
}

variable "node_group_name" {
  type        = string
  default     = "fiap-hackathon-node-group"
  description = "EKS Cluster name"
}

variable "iam_role_name" {
  type        = string
  default     = "LabRole"
  description = "IAM Role Name"
}

variable "vpc_name" {
  type        = string
  default     = "fiap-hackathon-vpc"
  description = "Private VPC name"
}

variable "rds_sg_name" {
  type        = string
  default     = "fiap-hackathon-rds-sg"
  description = "Security Group of the RDS instances"
}

variable "elasticache_sg_name" {
  type        = string
  default     = "fiap-hackathon-elasticache-sg"
  description = "Security Group of the Elasticache"
}

