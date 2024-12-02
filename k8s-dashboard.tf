resource "helm_release" "kubernetes-dashboard" {
  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  version    = "7.4.0"

  wait = false
  create_namespace = true
  namespace = "kubernetes-dashboard"
  replace = true

  values = [
    "${templatefile("${path.module}/files/values/kubernetes-dashboard.yaml", {ingress_host = "dashboard.apps.${var.name}.myltd.lab"})}"
  ]

  depends_on = [ 
    helm_release.internal_nginx,
    helm_release.cert-manager
  ]
}