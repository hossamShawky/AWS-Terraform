#VPC Module

module "VPC" {
  source     = "./modules/VPC"
  cidr_block = "12.0.0.0/16"
  project    = var.project
}

#@Subnets

module "Public_Subnets" {
  source             = "./modules/Subnets"
  vpc_id             = module.VPC.vpc_id
  igw                = module.VPC.igw
  project            = var.project
  destination        = "0.0.0.0/0"
  cidrs              = ["12.0.1.0/24", "12.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  type               = "public"

}

#SG

module "SG" {
  source  = "./modules/SG"
  vpc_id  = module.VPC.vpc_id
  project = var.project
}