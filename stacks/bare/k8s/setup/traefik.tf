resource "kubernetes_manifest" "traefik_dashboard_ingress" {
  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRoute"
    metadata = {
      name      = "dashboard"
      namespace = "traefik"
    }
    spec = {
      entryPoints = ["web"]
      routes = [{
        match = "Host(`traefik.homecluster`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))"
        kind  = "Rule"
        services = [{
          name = "api@internal"
          kind = "TraefikService"
        }]
      }]
    }
  }
}
