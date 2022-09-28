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

      operator = {
        replicas = 1
      }

      hubble = {
        ui = {
          enabled  = true
          replicas = 1
          ingress = {
            enabled = true
            hosts   = ["hubble.network.k8s.homecluster.local"]
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
