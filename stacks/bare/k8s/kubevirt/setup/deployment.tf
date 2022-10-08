resource "kubernetes_deployment" "virt_operator" {
  metadata {
    name      = "virt-operator"
    namespace = kubernetes_namespace.kubevirt.metadata[0].name

    labels = {
      "kubevirt.io" = "virt-operator"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        "kubevirt.io" = "virt-operator"
      }
    }

    template {
      metadata {
        name = "virt-operator"

        labels = {
          "kubevirt.io"            = "virt-operator"
          "prometheus.kubevirt.io" = "true"
          name                     = "virt-operator"
        }
      }

      spec {
        volume {
          name = "kubevirt-operator-certs"

          secret {
            secret_name = "kubevirt-operator-certs"
            optional    = true
          }
        }

        volume {
          name = "profile-data"
          empty_dir {}
        }

        container {
          name    = "virt-operator"
          image   = "quay.io/kubevirt/virt-operator:v0.57.1"
          command = ["virt-operator"]
          args    = ["--port", "8443", "-v", "2"]

          port {
            name           = "metrics"
            container_port = 8443
            protocol       = "TCP"
          }

          port {
            name           = "webhooks"
            container_port = 8444
            protocol       = "TCP"
          }

          env {
            name  = "OPERATOR_IMAGE"
            value = "quay.io/kubevirt/virt-operator:v0.57.1"
          }

          env {
            name = "WATCH_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.annotations['olm.targetNamespaces']"
              }
            }
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "250Mi"
            }
          }

          volume_mount {
            name       = "kubevirt-operator-certs"
            read_only  = true
            mount_path = "/etc/virt-operator/certificates"
          }

          volume_mount {
            name       = "profile-data"
            mount_path = "/profile-data"
          }

          readiness_probe {
            http_get {
              path   = "/metrics"
              port   = "8443"
              scheme = "HTTPS"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 10
          }

          image_pull_policy = "IfNotPresent"
        }

        node_selector = {
          "kubernetes.io/os"   = "linux"
          "kubernetes.io/arch" = "amd64"
        }

        service_account_name = kubernetes_service_account.kubevirt_operator.metadata[0].name
        priority_class_name  = "kubevirt-cluster-critical"

        security_context {
          run_as_non_root = true
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1

              pod_affinity_term {
                label_selector {
                  match_expressions {
                    key      = "kubevirt.io"
                    operator = "In"
                    values   = ["virt-operator"]
                  }
                }

                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }

        toleration {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }

      }
    }

    strategy {
      type = "RollingUpdate"
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.kubevirt_operator,
    kubernetes_role_binding.kubevirt_operator,
  ]
}