variable "name" {
}

variable "region" {
}

variable "aws_vpc_id" {
}

variable "aws_subnet_a" {
}

variable "aws_subnet_b" {
}

variable "aws_subnet_c" {
}

variable "aws_iam_role_k8s_api" {
  default = "default-eks-cluster-sa"
}

variable "aws_iam_role_k8s_node" {
  default = "default-eks-nodes-sa"
}

variable "aws_iam_role_k8s_vpc_cni" {
  default = "default-eks-vpc-cni-sa"
}

variable "aws_iam_role_k8s_lbc" {
  default = "default-eks-lbc-sa"
}

variable "aws_iam_role_k8s_ebs_csi" {
  default = "default-eks-ebc-csi-sa"
}

variable "aws_route53_zone_id" {
}

data "aws_vpc" "lab-vpc" {
  id = var.aws_vpc_id
}

data "aws_subnet" "lab-a" {
  id = var.aws_subnet_a
}

data "aws_subnet" "lab-b" {
  id = var.aws_subnet_b
}

data "aws_subnet" "lab-c" {
  id = var.aws_subnet_c
}

data "aws_iam_role" "eks-cluster-sa" {
  name = var.aws_iam_role_k8s_api
}

data "aws_iam_role" "eks-node-sa" {
  name = var.aws_iam_role_k8s_node
}

data "aws_iam_role" "eks-vpc-cni-sa" {
  name = var.aws_iam_role_k8s_vpc_cni
}

data "aws_iam_role" "eks-lbc-sa" {
  name = var.aws_iam_role_k8s_lbc
}

data "aws_iam_role" "eks-ebc-csi-sa" {
  name = var.aws_iam_role_k8s_ebs_csi
}

data "aws_eks_cluster" "main" {
  name = aws_eks_cluster.main.name
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}

data "tls_certificate" "eks-api" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}