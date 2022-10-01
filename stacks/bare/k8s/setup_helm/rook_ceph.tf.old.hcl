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

  depends_on = [helm_release.kube_prometheus]
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

  values = [
    yamlencode({
      operatorNamespace = "rook-ceph-system"

      configOverride = <<-EOT
      [global]
      osd_pool_default_size = 2
      mon_warn_on_pool_no_redundancy = false
      EOT

      monitoring = {
        enabled = true
      }

      toolbox = {
        enabled = true
        resources = {
          limits = {
            memory = "512Mi"
          }
        }
      }

      cephClusterSpec = {
        mon = {
          count = 2 # padrão: 3
          # allowMultiplePerNode = true # padrão: false
        }
        mgr = {
          count = 1 # padrão: 2
          # allowMultiplePerNode = true # padrão: false
        }
        dashboard = {
          ssl = false # padrão true
        }
        placement = {
          all = {
            nodeAffinity = {
              requiredDuringSchedulingIgnoredDuringExecution = {
                nodeSelectorTerms = [{
                  matchExpressions = [{
                    key      = "node-role.kubernetes.io/storage"
                    operator = "Exists"
                  }]
                }]
              }
            }
          }
        }
        resources = {
          # Necssário para discos maiores de 1TB (da erro ao gerar ao preparar o osd)
          prepareosd = {
            limits = {
              memory = "1Gi"
            }
          }
        }
      }

      ingress = {
        dashboard = {
          host = {
            name = "ceph.storage.k8s.homecluster.local"
            path = "/ceph-dashboard(/|$)(.*)"
          }
        }
      }

      cephFileSystems = []
      cephObjectStores = []
    })
  ]

  set {
    name = "cephBlockPools[0].spec.replicated.size"
    value = 2 # padrão 3
  }

  depends_on = [helm_release.rook_ceph_operator]
}
