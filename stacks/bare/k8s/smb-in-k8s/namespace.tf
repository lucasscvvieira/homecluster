resource "kubernetes_namespace" "samba_in_kubernetes" {
  metadata {
    name = "samba-in-kubernetes"
  }
}