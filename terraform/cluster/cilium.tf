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
    name  = "hubble.relay.enabled"
    value = true
  }

  set {
    name  = "hubble.ui.enabled"
    value = true
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
}
