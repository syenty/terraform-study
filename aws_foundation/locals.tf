module "tags" {
  source  = "../modules/tags"
  project = var.project_name
  env     = "dev"
  owner   = "devops"
}
