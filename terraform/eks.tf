resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = data.aws_iam_role.lab_role.arn

  vpc_config {
    subnet_ids = [for subnet in data.aws_subnet.selected_subnets : subnet.id]
  }

  enabled_cluster_log_types = ["api", "audit"]
  version                   = "1.32"

  depends_on = [
    data.aws_iam_role.lab_role
  ]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = data.aws_iam_role.lab_role.arn

  subnet_ids = [for subnet in data.aws_subnet.selected_subnets : subnet.id]

  instance_types = ["t3.large"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}

resource "aws_security_group_rule" "allow_app_to_sonarqube_rds_instance" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds_security_group.id
  source_security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "allow_app_to_elasticache" {
  type                     = "ingress"
  from_port                = 11211
  to_port                  = 11211
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.elasticache_security_group.id
  source_security_group_id = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}
