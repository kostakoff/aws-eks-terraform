terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.16.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    tls = {}
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
    kubernetes{
        host  = data.aws_eks_cluster.main.endpoint
        token = data.aws_eks_cluster_auth.main.token
        cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    }
}

provider "kubectl" {
  host  = data.aws_eks_cluster.main.endpoint
  token = data.aws_eks_cluster_auth.main.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  load_config_file       = false
}
