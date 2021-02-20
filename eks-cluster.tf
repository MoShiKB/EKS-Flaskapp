
locals {
  cluster_name = "My-EKS-Cluster"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.18"
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_private_access = "true"

  tags = {
    Name    = "EKS-Cluster"
    Version = "1.18"
  }

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "eks-workers"
      instance_type                 = "t2.small"
      #workers_default_ami_id        = lookup(var.AMIS, var.AWS_REGION)
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.worker-SG.id]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}