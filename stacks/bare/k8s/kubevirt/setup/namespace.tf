resource "kubernetes_namespace" "kubevirt" {
  metadata {
    name = "kubevirt"
  }
}