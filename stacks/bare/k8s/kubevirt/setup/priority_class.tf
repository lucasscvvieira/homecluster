resource "kubernetes_priority_class" "kubevirt_cluster_critical" {
  metadata {
    name = "kubevirt-cluster-critical"
  }

  value       = 1000000000
  description = "This priority class should be used for core kubevirt components only."
}