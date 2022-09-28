resource "helm_release" "kube_prometheus" {
  name       = "kube-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "40.1.2"

  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  values = [
    yamlencode({
      alertmanager = {
        ingress = {
          enabled = true
          hosts   = ["alertmanager.monitoring.k8s.homecluster.local"]
        }
      }

      grafana = {
        ingress = {
          enabled = true
          hosts   = ["grafana.monitoring.k8s.homecluster.local"]
        }
      }

      coreDns = {
        service = {
          selector = {
            "app.kubernetes.io/instance" = "coredns"
            "app.kubernetes.io/name"     = "coredns"
            "k8s-app"                    = "coredns"
          }
        }
      }
    })
  ]

  depends_on = [helm_release.cilium]
}
