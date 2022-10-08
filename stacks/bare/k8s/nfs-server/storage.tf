resource "kubernetes_persistent_volume_claim" "nfs_share_storage" {
  for_each = var.shares

  metadata {
    name      = "${each.key}-share-pvc"
    namespace = kubernetes_namespace.nfs_server.metadata[0].name
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
