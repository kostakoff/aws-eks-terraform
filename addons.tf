resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "kube-proxy"
  addon_version = "v1.31.2-eksbuild.3"
}

# install vpc cni
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
  addon_version = "v1.19.0-eksbuild.1"
  pod_identity_association {
    role_arn = data.aws_iam_role.eks-vpc-cni-sa.arn
    service_account = "aws-node"
  }
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "eks-pod-identity-agent"
  addon_version = "v1.3.4-eksbuild.1"
}

# install kube dns, through aws add-on
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "coredns"
  addon_version = "v1.11.3-eksbuild.1"

  depends_on = [ 
    aws_eks_node_group.general
  ]
}

# install ebc csi driver through add-on
resource "aws_eks_addon" "ebs-csi-driver" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.37.0-eksbuild.1"

  pod_identity_association {
    role_arn = data.aws_iam_role.eks-ebc-csi-sa.arn
    service_account = "ebs-csi-controller-sa"
  }

  depends_on = [
    aws_eks_node_group.general
  ]
}