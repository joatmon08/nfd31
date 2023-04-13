resource "random_password" "boundary_database" {
  length      = 12
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}

module "boundary" {
  source                       = "joatmon08/boundary/aws"
  version                      = "0.3.1"
  name                         = "${var.main_project_tag}-boundary"
  allow_cidr_blocks_to_api     = var.allow_cidr_blocks
  allow_cidr_blocks_to_workers = var.allow_cidr_blocks
  boundary_db_username         = var.boundary_db_username
  boundary_db_password         = random_password.boundary_database.result
  private_subnet_ids           = module.aws.private_subnets
  public_subnet_ids            = module.aws.public_subnets
  vpc_cidr_block               = module.aws.vpc_cidr_block
  vpc_id                       = module.aws.vpc_id
}

module "boundary" {
  source                       = "joatmon08/boundary/aws"
  version                      = "0.3.1"
  name                         = "${var.main_project_tag}-boundary-v2"
  allow_cidr_blocks_to_api     = var.allow_cidr_blocks
  allow_cidr_blocks_to_workers = var.allow_cidr_blocks
  boundary_db_username         = var.boundary_db_username
  boundary_db_password         = random_password.boundary_database.result
  private_subnet_ids           = module.aws_v2.private_subnets
  public_subnet_ids            = module.aws_v2.public_subnets
  vpc_cidr_block               = module.aws_v2.vpc_cidr_block
  vpc_id                       = module.aws_v2.vpc_id
}