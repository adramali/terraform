generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = file("${get_terragrunt_dir()}/../provider-config/provider.tf")
}
