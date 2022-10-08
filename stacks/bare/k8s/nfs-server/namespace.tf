resource "kubernetes_namespace" "nfs_server" {
  metadata {
    name = "nfs-server"
  }
}