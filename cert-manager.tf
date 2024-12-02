resource "helm_release" "cert-manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "v1.15.0"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    aws_eks_node_group.general,
    helm_release.internal-nginx
  ]
}

resource "kubectl_manifest" "cert-manager-dev-issuer" {
  yaml_body = <<YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: selfsigned-cluster-issuer
    spec:
      selfSigned: {}
  YAML
  apply_only = true
  
  depends_on = [
    helm_release.cert-manager
  ]
}
