resource "kubernetes_labels" "k3s-arm64-02" {
  api_version = "v1"
  kind        = "Node"
  force       = true

  metadata {
    name = "k3s-arm64-02"
  }

  labels = {
    "node-role.kubernetes.io/storage"      = true
    "node.longhorn.io/create-default-disk" = "config"
  }

  depends_on = [
    helm_release.cilium,
  ]
}

resource "kubernetes_labels" "k3s-amd64-01" {
  api_version = "v1"
  kind        = "Node"

  metadata {
    name = "k3s-amd64-01"
  }

  labels = {
    "node-role.kubernetes.io/storage"      = true
    "node-role.kubernetes.io/gpu"          = true
    "node.longhorn.io/create-default-disk" = "config"
  }

  depends_on = [
    helm_release.cilium,
  ]
}

# Existe um bug em que as labels fica alterando com os annotations
# https://github.com/hashicorp/terraform-provider-kubernetes/pull/1831

# resource "kubernetes_annotations" "k3s02" {
#   api_version = "v1"
#   kind        = "Node"
#   force       = true

#   metadata {
#     name = "k3s-02"
#   }

#   annotations = {
#     "node.longhorn.io/default-disks-config" = jsonencode([
#       {
#         path            = "/mnt/longhorn/ad6ff050-9453-42ec-b367-c288f500c6b8"
#         allowScheduling = true
#       },
#     ])
#   }

#   depends_on = [
#     helm_release.cilium,
#   ]
# }

# resource "kubernetes_annotations" "k3s03" {
#   api_version = "v1"
#   kind        = "Node"

#   metadata {
#     name = "k3s-03"
#   }

#   annotations = {
#     "node.longhorn.io/default-disks-config" = jsonencode([
#       {
#         path            = "/mnt/longhorn/ddd27541-4f0b-4a48-b311-22c00a591490"
#         allowScheduling = true
#       },
#     ])
#   }

#   depends_on = [
#     helm_release.cilium,
#   ]
# }
