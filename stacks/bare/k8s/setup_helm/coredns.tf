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
    value = data.terraform_remote_state.k8s_init.outputs.network.dns_ip
  }

  set {
    name  = "prometheus.service.enabled"
    value = true
  }

  set {
    name  = "prometheus.monitor.enabled"
    value = true
  }

  set {
    name  = "prometheus.monitor.namespace"
    value = "monitoring"
  }

  depends_on = [helm_release.kube_prometheus]
}
