resource "kubernetes_service_account" "kubevirt_operator" {
  metadata {
    name      = "kubevirt-operator"
    namespace = kubernetes_namespace.kubevirt.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "kubevirt_operator" {
  metadata {
    name = "kubevirt-operator"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kubevirt_operator.metadata[0].name
    namespace = kubernetes_namespace.kubevirt.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kubevirt_operator.metadata[0].name
  }
}

resource "kubernetes_role_binding" "kubevirt_operator" {
  metadata {
    name      = "kubevirt-operator-rolebinding"
    namespace = kubernetes_namespace.kubevirt.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kubevirt_operator.metadata[0].name
    namespace = kubernetes_namespace.kubevirt.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.kubevirt_operator.metadata[0].name
  }
}