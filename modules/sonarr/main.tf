resource "kubernetes_persistent_volume_claim" "sonarr" {
  metadata {
    name      = "sonarr-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "local-path"

    resources {
      requests = {
        storage = "2Mi"
      }
    }
  }

  wait_until_bound = false
}

resource "kubernetes_config_map" "sonarr" {
  metadata {
    name      = "sonarr-config"
    namespace = var.namespace
  }

  data = {
    "PUID" = 1000
    "PGID" = 1000
    "TZ"   = "Europe/Oslo"
  }
}

resource "kubernetes_deployment" "sonarr" {
  metadata {
    name      = "sonarr"
    namespace = var.namespace
    labels = {
      "servarr.app" = "sonarr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "servarr.app" = "sonarr"
      }
    }

    template {
      metadata {
        labels = {
          "servarr.app" = "sonarr"
        }
      }

      spec {
        container {
          image = "lscr.io/linuxserver/sonarr:latest"
          name  = "sonarr"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.sonarr.metadata.0.name
            }
          }

          port {
            container_port = 8989
          }

          volume_mount {
            name       = "data"
            mount_path = "/config"
          }

          volume_mount {
            name       = "downloads"
            mount_path = "/downloads"
          }

          volume_mount {
            name       = "tv"
            mount_path = "/tv"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sonarr.metadata.0.name
          }
        }

        volume {
          name = "downloads"
          persistent_volume_claim {
            claim_name = var.volume_downloads
          }
        }

        volume {
          name = "tv"
          persistent_volume_claim {
            claim_name = var.volume_tv
          }
        }

      }
    }
  }
}

resource "kubernetes_service" "sonarr" {
  metadata {
    name      = "sonarr"
    namespace = var.namespace
  }

  spec {
    type = "LoadBalancer"

    selector = {
      "servarr.app" = "sonarr"
    }

    port {
      port = 8989
    }
  }

  depends_on = [
    kubernetes_deployment.sonarr
  ]
}
