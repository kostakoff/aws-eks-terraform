resource "helm_release" "internal_nginx" {
  name = "internal"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = "4.10.1"

  values = [file("${path.module}/files/values/nginx-ingress.yaml")]

  depends_on = [helm_release.aws-lbc]
}

data "aws_lb" "nginx-ingress" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.name
    "service.k8s.aws/stack" = "ingress/internal-ingress-nginx-controller"
  }

  depends_on = [
    helm_release.internal_nginx
  ]
}

resource "aws_route53_record" "ingess" {
  zone_id = var.aws_route53_zone_id
  name    = "*.apps.${var.name}.myltd.lab"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_lb.nginx-ingress.dns_name]
}
