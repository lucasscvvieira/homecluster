resource "kubernetes_labels" "k3s02_roles" {
  api_version = "v1"
  kind        = "Node"

  metadata {
    name = "k3s-02"
  }

  labels = {
    "node-role.kubernetes.io/storage" = true
  }
}

resource "kubernetes_labels" "k3s03_roles" {
  api_version = "v1"
  kind        = "Node"

  metadata {
    name = "k3s-03"
  }

  labels = {
    "node-role.kubernetes.io/storage" = true
    "node-role.kubernetes.io/gpu"     = true
  }
}
