resource "kubernetes_deployment" "nfs_server" {
  for_each = var.shares

  metadata {
    name      = "${each.key}-nfs-server"
    namespace = kubernetes_namespace.nfs_server.metadata[0].name
    labels = {
      role = "nfs-server"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        role = "nfs-server"
      }
    }

    template {
      metadata {
        labels = {
          role = "nfs-server"
        }
      }

      spec {
        volume {
          name = "share-pvc"
          persistent_volume_claim {
            claim_name = "${each.key}-share-pvc"
          }
        }

        container {
          image = "k8s.gcr.io/volume-nfs:0.8"
          name  = "nfs-server"

          port {
            name           = "nfs"
            container_port = 2049
          }

          port {
            name           = "mountd"
            container_port = 20048
          }

          port {
            name           = "rpcbind"
            container_port = 111
          }

          security_context {
            privileged = true
          }

          volume_mount {
            mount_path = "/exports"
            name       = "share-pvc"
          }

          # resources {
          #   limits = {
          #     cpu    = "0.5"
          #     memory = "512Mi"
          #   }
          #   requests = {
          #     cpu    = "250m"
          #     memory = "50Mi"
          #   }
          # }

          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 80
          #
          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }
          #
          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}
