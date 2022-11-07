resource "kubernetes_manifest" "nfs_server_ingress" {
  # Somente um share pode ser exportado pelo ingress
  for_each = toset(slice(keys(var.shares), 0, 1))

  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRouteTCP"

    metadata = {
      name      = "${each.key}-nfs-server"
      namespace = kubernetes_namespace.nfs_server.metadata[0].name
    }

    spec = {
      entryPoints = ["nfs"]
      routes = [{
        match = "HostSNI(`*`)"
        services = [{
          name = kubernetes_service.nfs_server[each.key].metadata[0].name 
          port = 2049
        }]
      }]
    }
  }
}
