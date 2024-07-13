terraform {
  cloud {
    organization = "southcity"

    workspaces {
      name = "Homelab"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "default"
}
