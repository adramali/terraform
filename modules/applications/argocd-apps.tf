
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"

}

locals {
  applications = [
    for app_key, app in var.apps : {
      name      = "${app_key}-app"
      namespace = "argocd"
      project   = "default"
      source = {
        repoURL        = "git@github.com:adramali/k8s-manifestfiles.git"
        targetRevision = "main"
        path           = app.path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "dev"
      }
      syncPolicy = {
        automated = {
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  ]
}

resource "kubernetes_manifest" "argocd_app" {
  for_each = { for app in local.applications : app.name => app }

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = each.value.name
      namespace = each.value.namespace
    }
    spec = {
      project     = each.value.project
      source      = each.value.source
      destination = each.value.destination
      syncPolicy  = each.value.syncPolicy
    }
  }
}