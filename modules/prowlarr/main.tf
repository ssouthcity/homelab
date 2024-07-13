resource "kubernetes_persistent_volume_claim" "prowlarr" {
  metadata {
    name      = "prowlarr-pvc"
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

resource "kubernetes_config_map" "prowlarr" {
  metadata {
    name      = "prowlarr-config"
    namespace = var.namespace
  }

  data = {
    "PUID" = 1000
    "PGID" = 1000
    "TZ"   = "Europe/Oslo"
  }
}

resource "kubernetes_deployment" "prowlarr" {
  metadata {
    name      = "prowlarr"
    namespace = var.namespace
    labels = {
      "servarr.app" = "prowlarr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "servarr.app" = "prowlarr"
      }
    }

    template {
      metadata {
        labels = {
          "servarr.app" = "prowlarr"
        }
      }

      spec {
        container {
          image = "lscr.io/linuxserver/prowlarr:latest"
          name  = "prowlarr"

          env_from {
            config_map_ref {
              name = kubernetes_config_map.prowlarr.metadata.0.name
            }
          }

          port {
            container_port = 9696
          }

          volume_mount {
            name       = "data"
            mount_path = "/config"
          }
        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.prowlarr.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "prowlarr" {
  metadata {
    name      = "prowlarr"
    namespace = var.namespace
  }

  spec {
    type = "LoadBalancer"

    selector = {
      "servarr.app" = "prowlarr"
    }

    port {
      port = 9696
    }
  }

  depends_on = [
    kubernetes_deployment.prowlarr
  ]
}
