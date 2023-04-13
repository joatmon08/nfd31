module "aws" {
  source           = "app.terraform.io/a-demo-organization/nfd31/aws"
  version          = "0.0.3"
  region           = var.region
  main_project_tag = var.main_project_tag
  network_cidr     = var.network_cidr
}

module "aws_v2" {
  source           = "app.terraform.io/a-demo-organization/nfd31/aws"
  version          = "0.0.4"
  region           = var.region
  main_project_tag = "${var.main_project_tag}-v2"
  network_cidr     = "10.128.0.0/20"
}