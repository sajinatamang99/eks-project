# Use the Terraform Helm provider to install Kubernetes add-ons:
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.13.3"

  create_namespace = true
  namespace        = "ingress-nginx"
  depends_on = [module.eks]

  values = [
    "${file("${path.module}/values/nginx-ingress.yaml")}"
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace        = "cert-manager"

  values = [
    "${file("${path.module}/values/cert-manager.yaml")}"
  ]

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  values = [
    "${file("${path.module}/values/external-dns.yaml")}"
  ]
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm/"
  chart      = "argo-cd"
  version    = "5.19.15"
  timeout    = "600"

  create_namespace = true
  namespace        = "argo-cd"

  values = [
    "${file("${path.module}/values/argocd.yaml")}"
  ]

  depends_on = [helm_release.nginx_ingress, helm_release.cert_manager, helm_release.external_dns]
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "78.3.1"

  create_namespace = true
  namespace        = "monitoring"

  values = [
    "${file("${path.module}/values/kube-prometheus-stack.yaml")}"
  ]

  depends_on = [helm_release.nginx_ingress, helm_release.cert_manager, helm_release.external_dns]
}

