resource "kubernetes_manifest" "smb_share_ingress" {
  # Somente um share pode ser exportado pelo ingress
  for_each = toset(slice(keys(var.shares), 0, 1))

  manifest = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind       = "IngressRouteTCP"

    metadata = {
      name      = kubernetes_manifest.smb_shares[each.key].manifest.metadata.name
      namespace = kubernetes_namespace.samba_in_kubernetes.metadata[0].name
    }

    spec = {
      entryPoints = ["samba"]
      routes = [{
        match = "HostSNI(`*`)"
        services = [{
          name = kubernetes_manifest.smb_shares[each.key].manifest.metadata.name
          port = 445
        }]
      }]
    }
  }
}
