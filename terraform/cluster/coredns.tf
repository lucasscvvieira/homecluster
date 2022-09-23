resource "helm_release" "coredns" {
  name       = "coredns"
  repository = "https://coredns.github.io/helm"
  chart      = "coredns"
  version    = "1.19.4"

  namespace     = "kube-system"
  wait_for_jobs = true

  set {
    name  = "resources.requests.memory"
    value = "70Mi"
  }

  set {
    name  = "service.clusterIP"
    value = module.k3s_cluster.network.dns_ip
  }

  set {
    name  = "prometheus.service.enabled"
    value = true
  }
}
