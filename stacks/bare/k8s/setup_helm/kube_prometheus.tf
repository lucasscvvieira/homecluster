resource "helm_release" "kube_prometheus" {
  name       = "kube-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "40.1.2"

  namespace        = "monitoring"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "alertmanager.ingress.enabled"
    value = true
  }

  set {
    name  = "alertmanager.ingress.hosts[0]"
    value = "alertmanager.monitoring.k8s.homecluster.local"
  }

  set {
    name  = "grafana.ingress.enabled"
    value = true
  }

  set {
    name  = "grafana.ingress.hosts[0]"
    value = "grafana.monitoring.k8s.homecluster.local"
  }

  depends_on = [helm_release.cilium]
}
