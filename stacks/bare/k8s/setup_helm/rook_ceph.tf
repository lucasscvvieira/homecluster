resource "helm_release" "rook_ceph_operator" {
  name       = "rook-ceph"
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph"
  version    = "1.10.1"

  namespace        = "rook-ceph-system"
  create_namespace = true
  wait             = true
  wait_for_jobs    = false

  set {
    name  = "csi.provisionerReplicas"
    value = 1
  }

  set {
    name  = "monitoring.enabled"
    value = true
  }

  depends_on = [helm_release.cilium]
}

resource "helm_release" "rook_ceph_cluster" {
  name       = "rook-ceph-cluster"
  repository = "https://charts.rook.io/release"
  chart      = "rook-ceph-cluster"
  version    = "1.10.1"

  namespace = "rook-ceph-system"

  # Não pode esperar porque a role de storage só é atribuída no próximo passo
  wait          = false
  wait_for_jobs = false

  set {
    name  = "operatorNamespace"
    value = "rook-ceph-system"
  }

  set {
    name  = "monitoring.enabled"
    value = true
  }

  set {
    name  = "toolbox.enabled"
    value = true
  }

  set {
    name  = "toolbox.resources.limits.memory"
    value = "512Mi"
  }

  # set {
  #   name = "cephClusterSpec.mon.count"
  #   value = 2 # padrão: 3
  # }

  set {
    name  = "cephClusterSpec.mon.allowMultiplePerNode"
    value = true # padrão: false
  }

  # set {
  #   name = "cephClusterSpec.mgr.count"
  #   value = 1 # padrão: 3
  # }

  set {
    name  = "cephClusterSpec.mgr.allowMultiplePerNode"
    value = true # padrão: false
  }

  # set {
  #   name = "cephClusterSpec.dashboard.ssl"
  #   value = false # padrão: true
  # }

  set {
    name  = "cephClusterSpec.placement.all.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value = "node-role.kubernetes.io/storage"
  }

  set {
    name  = "cephClusterSpec.placement.all.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value = "Exists"
  }

  # set {
  #   name = "cephClusterSpec.placement.all.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].values[0]"
  #   value = "storage"
  # }

  set {
    name  = "ingress.dashboard.host.name"
    value = "ceph.storage.k8s.homecluster.local"
  }

  # set {
  #   name = "ingress.dashboard.host.path"
  #   value = "/ceph-dashboard(/|$)(.*)"
  # }

  # Necssário para discos maiores de 1TB (da erro ao gerar ao preparar o osd)
  set {
    name  = "cephClusterSpec.resources.prepareosd.limits.memory"
    value = "1Gi"
  }

  depends_on = [helm_release.rook_ceph_operator]
}
