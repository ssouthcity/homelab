
resource "kubernetes_namespace" "servarr" {
  metadata {
    name = "servarr"
  }
}

resource "kubernetes_persistent_volume_claim" "servarr_tv" {
  metadata {
    name      = "servarr-tv"
    namespace = kubernetes_namespace.servarr.metadata.0.name
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "128Gi"
      }
    }
  }

  wait_until_bound = false
}

resource "kubernetes_persistent_volume_claim" "servarr_downloads" {
  metadata {
    name      = "servarr-downloads"
    namespace = kubernetes_namespace.servarr.metadata.0.name
  }

  spec {
    storage_class_name = "local-path"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "128Gi"
      }
    }
  }

  wait_until_bound = false
}

module "prowlarr" {
  source = "./modules/prowlarr"

  namespace = kubernetes_namespace.servarr.metadata.0.name
}

module "sonarr" {
  source = "./modules/sonarr"

  namespace        = kubernetes_namespace.servarr.metadata.0.name
  volume_downloads = kubernetes_persistent_volume_claim.servarr_downloads.metadata.0.name
  volume_tv        = kubernetes_persistent_volume_claim.servarr_tv.metadata.0.name
}
