resource "kubernetes_service" "nfs_server" {
  for_each = var.shares

  metadata {
    name      = "${each.key}-nfs-server"
    namespace = kubernetes_namespace.nfs_server.metadata[0].name
  }

  spec {
    selector = {
      role = "nfs-server"
    }
    session_affinity = "ClientIP"
    port {
      name        = "nfs"
      port        = 2049
      protocol    = "TCP"
    }
    port {
      name        = "mountd"
      port        = 20048
      protocol    = "TCP"
    }
    port {
      name        = "rpcbind"
      port        = 111
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
