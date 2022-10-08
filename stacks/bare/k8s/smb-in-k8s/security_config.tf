resource "kubernetes_manifest" "smb_security_configs" {
  for_each = var.shares

  manifest = {
    apiVersion = "samba-operator.samba.org/v1alpha1"
    kind       = "SmbSecurityConfig"

    metadata = {
      name      = "${each.key}-security"
      namespace = kubernetes_namespace.samba_in_kubernetes.metadata[0].name
    }

    spec = {
      mode = "user"
      users = {
        secret = kubernetes_secret.smb_users_secrets[each.key].metadata[0].name
        key    = "smb_users"
      }
    }
  }
}
