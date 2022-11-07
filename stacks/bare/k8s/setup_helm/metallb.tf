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

  values = [
    yamlencode({
      # prometheus = {
      #   serviceMonitor = {
      #     enabled = true
      #     prometheusRule = {
      #       enabled = true
      #     }
      #   }
      # }

      # controller = {
      #   affinity    = local.master_affinity
      #   tolerations = local.master_tolerations
      # }

      # speaker = {
      #   affinity    = local.master_affinity
      #   tolerations = local.master_tolerations
      # }
    })
  ]

  depends_on = [helm_release.kube_prometheus]
}
