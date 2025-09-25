variable "apps" {
  type = map(object({
    path = string
  }))
  default = {
    backend  = { path = "backend" }
    frontend = { path = "frontend" }
    mysql    = { path = "mysql" }
  }
}