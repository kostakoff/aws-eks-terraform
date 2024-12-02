resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.main.name
  version = "1.31"
  node_group_name = "${var.name}-general"
  node_role_arn   = data.aws_iam_role.eks-node-sa.arn

  subnet_ids      = [data.aws_subnet.lab-a.id]
  
  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  instance_types = ["t3.medium"]
  disk_size = "30"

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 2
  }
  
  labels = {
    "role" = "general"
  }

  remote_access {
    ec2_ssh_key = "main-key"
  }

  lifecycle {
    ignore_changes = [ scaling_config[0].desired_size ]
  }

  depends_on = [ 
    kubectl_manifest.aws-auth,
    aws_eks_addon.vpc-cni,
    aws_eks_addon.kube-proxy,
    aws_eks_addon.eks-pod-identity-agent,
    aws_iam_openid_connect_provider.eks-api
  ]
}