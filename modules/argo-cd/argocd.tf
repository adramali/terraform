
provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "minikube"
  }
}

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
