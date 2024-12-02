resource "aws_eks_pod_identity_association" "aws-lbc" {
  cluster_name = aws_eks_cluster.main.name
  namespace = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn = data.aws_iam_role.eks-lbc-sa.arn
}

resource "helm_release" "aws-lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.main.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.lab-vpc.id
  }

  depends_on = [
    aws_eks_node_group.general
  ]
}
