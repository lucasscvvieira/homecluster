resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.3.1"

  namespace        = "longhorn-system"
  create_namespace = true
  wait_for_jobs    = true

  values = [
    yamlencode({
      persistence = {
        defaultClassReplicaCount = 3
        # defaultDataLocality = "best-effort"
      }

      defaultSettings = {
        replicaAutoBalance            = "least-effort"
        createDefaultDiskLabeledNodes = true
      }

      ingress = {
        enabled = true
        host    = "longhorn.storage.k8s.homecluster.local"
      }
    })
  ]

  depends_on = [
    helm_release.coredns,
    kubernetes_labels.k3s02,
    # kubernetes_annotations.k3s02,
    kubernetes_labels.k3s03,
    # kubernetes_annotations.k3s03,
  ]
}
