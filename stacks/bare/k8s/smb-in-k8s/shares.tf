resource "kubernetes_manifest" "smb_shares" {
  for_each = var.shares

  manifest = {
    apiVersion = "samba-operator.samba.org/v1alpha1"
    kind       = "SmbShare"

    metadata = {
      name      = "${each.key}-share"
      namespace = kubernetes_namespace.samba_in_kubernetes.metadata[0].name
    }

    spec = {
      shareName      = each.key
      securityConfig = kubernetes_manifest.smb_security_configs[each.key].manifest.metadata.name
      readOnly       = false
      storage = {
        pvc = {
          name = kubernetes_persistent_volume_claim.smb_shares_storage[each.key].metadata[0].name
        }
      }
    }
  }
}
