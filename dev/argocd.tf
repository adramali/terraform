module "argocd" {
  source          = "../modules/argo-cd"
}

module "applications" {
  source = "../modules/applications"

  apps = {
    myapp = {
      path = "myapp"
    }
  }

}
