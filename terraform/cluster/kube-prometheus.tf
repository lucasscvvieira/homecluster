resource "helm_release" "kube_prometheus" {
  name       = "kube-prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "40.1.2"

  namespace        = "monitoring"
  create_namespace = true
  wait_for_jobs    = true

  depends_on = [module.k3s_cluster]
}
