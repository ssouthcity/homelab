
resource "kubernetes_namespace" "servarr" {
  metadata {
    name = "servarr"
  }
}

module "prowlarr" {
  source = "./modules/prowlarr"

  namespace = kubernetes_namespace.servarr.metadata.0.name
}
