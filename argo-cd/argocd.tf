
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  values = [
    yamlencode({
      configs = {
        secret = {
          argocdServerAdminUser     = "malli"
          argocdServerAdminPassword = "$2y$10$1f7nMguna0MliD2r8bxEGOYmpxRwMLTX6gAq42nAMBqu/uWvBRQE2%"
        }
        repositories = {
          manifestfiles = {
            url           = "git@github.com:adramali/k8s-manifestfiles.git"
            type          = "git"
            sshPrivateKey = file("${path.module}/argocd")
          }
        }
      }
    })
  ]
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