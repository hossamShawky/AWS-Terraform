#VPC Module

module "VPC" {
  source     = "./modules/VPC"
  cidr_block = "12.0.0.0/16"
  project    = var.project
}