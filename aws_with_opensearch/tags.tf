module "tags" {
  source  = "../modules/tags"
  project = var.project_name
  env     = var.env
  owner   = var.owner
}
