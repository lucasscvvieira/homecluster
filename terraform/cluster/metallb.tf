resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.13.5"

  namespace        = "metallb-system"
  create_namespace = true
  wait_for_jobs    = true

  # set {
  #   name = "prometheus.serviceMonitor.enabled"
  #   value = true
  # }
  #
  # set {
  #   name = "prometheus.namespace"
  #   value = "monitoring"
  # }

  depends_on = [module.k3s_cluster]
}

resource "kubernetes_manifest" "metallb_config" {
  manifest = {
    apiVersion = "metallb.io/v1beta1"
    kind = "IPAddressPool"
    metadata = {
      name = "production"
      namespace = "metallb-system"
    }
    spec = {
      addresses = ["192.168.0.224/29"]
    }
  }

  depends_on = [helm_release.metallb]
}
