terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      #version = ""
    }
  }
}

provider "helm" {

  # kubernetes {
  #   host                   = module.aks.host
  #   client_certificate     = base64decode(module.aks.client_certificate)
  #   client_key             = base64decode(module.aks.client_key)
  #   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  # }

  kubernetes {
    config_path = "./kubeconfig"
  }

}

module "helm_config" {
  source = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//helm?ref=main"
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.42.1"
  namespace  = "argocd"

  set {
    name  = "installCRDs"
    value = true
  }

  wait          = false
  wait_for_jobs = false

  create_namespace = true

}