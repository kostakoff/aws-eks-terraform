# kreate kube api server
resource "aws_eks_cluster" "main" {
  name     = var.name
  role_arn = data.aws_iam_role.eks-cluster-sa.arn
  version  = "1.31"

  vpc_config {
    security_group_ids = [ aws_security_group.kube-default.id ]
    subnet_ids = [
      data.aws_subnet.lab-a.id,
      data.aws_subnet.lab-b.id,
      data.aws_subnet.lab-c.id
    ]

    endpoint_private_access = true
    endpoint_public_access  = false
  }
  enabled_cluster_log_types = [ ]
  bootstrap_self_managed_addons = false

  zonal_shift_config {
    enabled = false
  }
  upgrade_policy {
    support_type = "STANDARD"
  }
  kubernetes_network_config {
    service_ipv4_cidr = "172.16.0.0/16"
    ip_family = "ipv4"
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

resource "aws_iam_openid_connect_provider" "eks-api" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-api.certificates[0].sha1_fingerprint]
  url             =  data.tls_certificate.eks-api.url
}

resource "kubectl_manifest" "aws-auth" {
  yaml_body = <<YAML
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: aws-auth
      namespace: kube-system
    data:
      mapRoles: 
      mapUsers: |
        - userarn: arn:aws:iam::684618363085:root
          username: eks-admin
          groups:
            - system:masters
  YAML
  apply_only = true
}