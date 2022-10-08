resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.24.3"

  namespace        = "traefik-system"
  create_namespace = true

  # Não pode esperar porque as configurações do load-balance acontecem
  # em outro passo, então, vai ficar como pending até lá.
  wait = false

  # set {
  #   name = "additionalArguments[0]"
  #   value = "--log.level=DEBUG"
  # }

  values = [
    yamlencode({
      deployment = {
        # Roda um ingress em cada nó master
        kind = "DaemonSet"
      }

      ingressClass = {
        enabled        = true
        isDefaultClass = true
      }

      ingressRoute = {
        dashboard = {
          enabled = false
        }
      }

      ports = {
        samba = {
          port     = 445
          expose   = true
          protocol = "TCP"
        }
      }

      affinity    = local.master_affinity
      tolerations = local.master_tolerations
    })
  ]

  depends_on = [helm_release.cilium]
}
