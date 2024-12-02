resource "helm_release" "prometheus" {
  name = "prometheus"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = "prometheus"
  create_namespace = true
  version          = "26.0.0"

  values = [
    "${templatefile("${path.module}/files/values/prometheus.yaml", {domain = "apps.${var.name}.myltd.lab"})}"
  ]

  depends_on = [
    helm_release.metrics-server,
    helm_release.internal-nginx,
    helm_release.cert-manager
  ]
}
