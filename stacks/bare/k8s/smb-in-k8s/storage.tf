resource "kubernetes_persistent_volume_claim" "smb_shares_storage" {
  for_each = var.shares

  metadata {
    name      = "${each.key}-share-pvc"
    namespace = kubernetes_namespace.samba_in_kubernetes.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "longhorn"

    resources {
      requests = {
        storage = each.value.storage.request
      }
    }
  }
}
