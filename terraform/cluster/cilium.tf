resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.12.2"

  namespace     = "kube-system"
  recreate_pods = true
  wait_for_jobs = true
  timeout       = 600

  set {
    name  = "kubeProxyReplacement"
    value = "strict"
  }

  set {
    name  = "operator.replicas"
    value = 1
  }

  set {
    name  = "hubble.ui.replicas"
    value = 1
  }

  set {
    name  = "ipam.operator.clusterPoolIPv4PodCIDRList[0]"
    value = module.k3s_cluster.network.cidr.cluster
  }

  set {
    name  = "ipam.operator.clusterPoolIPv4MaskSize"
    value = "22"
  }

  dynamic "set" {
    for_each = ["dns:query;ignoreAAAA", "drop", "tcp", "flow", "icmp", "http"]
    content {
      name  = "hubble.metrics.enabled[${set.key}]"
      value = set.value
    }
  }

  # Habilita serviços
  dynamic "set" {
    for_each = [
      "prometheus.enabled",
      "prometheus.serviceMonitor.enabled",
      "operator.prometheus.enabled",
      "operator.prometheus.serviceMonitor.enabled",
      "hubble.metrics.serviceMonitor.enabled",
      "hubble.relay.enabled",
      "hubble.relay.prometheus.enabled",
      "hubble.relay.prometheus.serviceMonitor.enabled",
      "hubble.ui.enabled",
    ]
    content {
      name  = set.value
      value = true
    }
  }

  depends_on = [helm_release.kube_prometheus]
}
