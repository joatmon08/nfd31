module "aws" {
  source           = "app.terraform.io/a-demo-organization/nfd31/aws"
  version          = "0.0.3"
  region           = var.region
  main_project_tag = var.main_project_tag
  network_cidr     = var.network_cidr
}

locals {
  main_project_tag_v2 = "${var.main_project_tag}-v2"
}