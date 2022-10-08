resource "kubernetes_secret" "smb_users_secrets" {
  for_each = var.shares

  metadata {
    name      = "${each.key}-users"
    namespace = kubernetes_namespace.samba_in_kubernetes.metadata[0].name
  }

  data = {
    smb_users = jsonencode({
      samba-container-config = "v0"
      users = {
        all_entries = [
          for user in each.value.users : {
            name     = user.username
            password = user.password
          }
        ]
      }
    })
  }

  type = "Opaque"
}
