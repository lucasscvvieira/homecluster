resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.12.2"

  namespace     = "kube-system"
  recreate_pods = true
  wait_for_jobs = true
  timeout       = 600

  values = [
    yamlencode({
      kubeProxyReplacement = "strict"

      resources = {
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
        requests = {
          cpu    = "100m"
          memory = "256Mi"
        }
      }

      operator = {
        # replicas = 1
        affinity    = local.master_affinity
        tolerations = local.master_tolerations

        resources = {
          limits = {
            cpu    = "250m"
            memory = "256Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "64Mi"
          }
        }
      }

      hubble = {
        ui = {
          enabled  = true
          replicas = 1
          ingress = {
            enabled = true
            hosts   = ["hubble.network.k8s.homecluster.local"]
          }
          backend = {
            resources = {
              limits = {
                cpu    = "150m"
                memory = "128Mi"
              }
              requests = {
                cpu    = "50m"
                memory = "64Mi"
              }
            }
          }
          frontend = {
            resources = {
              limits = {
                cpu    = "10m"
                memory = "32Mi"
              }
              requests = {
                cpu    = "1m"
                memory = "16Mi"
              }
            }
          }
        }
        metrics = {
          enabled = [
            "dns:query;ignoreAAAA",
            "drop",
            "tcp",
            "flow",
            "icmp",
            "http",
          ]
        }
        relay = {
          enabled = true
        }
      }

      ipam = {
        operator = {
          clusterPoolIPv4PodCIDRList = [
            data.terraform_remote_state.k8s_init.outputs.network.cidr.cluster,
          ]
          clusterPoolIPv4MaskSize = "22"
        }
      }
    })
  ]

  #depends_on = [helm_release.kube_prometheus]
}
