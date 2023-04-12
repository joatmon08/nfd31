module "aws" {
  source           = "app.terraform.io/a-demo-organization/nfd31/aws"
  version          = "0.0.1"
  region           = var.region
  main_project_tag = var.main_project_tag
  network_cidr     = var.network_cidr
}