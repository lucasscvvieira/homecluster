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

      prometheusOperator = {
        resources = {
          limits = {
            cpu    = "200m"
            memory = "200Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "100Mi"
          }
        }

        affinity = {
          nodeAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = {
              nodeSelectorTerms = [{
                matchExpressions = [{
                  key      = "node-role.kubernetes.io/master"
                  operator = "Exists"
                }]
              }]
            }
          }
        }

        tolerations = [{
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
          effect   = "NoSchedule"
        }]
      }

      prometheus = {
        prometheusSpec = {
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "longhorn"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "50Gi"
                  }
                }
              }
            }
          }
        }
      }
    })
  ]

  depends_on = [helm_release.longhorn]
}
