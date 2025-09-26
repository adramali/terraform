resource "kubernetes_secret" "docker_registry" {
  metadata {
    name      = "docker-registry"
    namespace = "dev" # Change if needed
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = "adramalli"
          password = "Malli@1996"
          email    = "adramallikarjuna@gmail.com"
          auth     = base64encode("adramalli:Malli@1996")
        }
      }
    })
  }

}

resource "kubernetes_secret" "db" {
  metadata {
    name      = "myapp-db-secret"
    namespace = "dev" # Change if needed
  }


  data = {
    MYSQL_USERNAME = "admin"
    MYSQL_PASSWORD = "Arjun@1720"
    MYSQL_DB       = "myapp"
  }

  type = "Opaque"
  
}