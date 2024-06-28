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
  depends_on         = [module.VPC]
}

#SG

module "SG" {
  source     = "./modules/SG"
  vpc_id     = module.VPC.vpc_id
  project    = var.project
  depends_on = [module.Public_Subnets]
}

#EC2s

module "EC2" {
  source         = "./modules/EC2"
  security_group = module.SG.security_group
  subnets        = module.Public_Subnets.subnets
  project        = var.project
  depends_on     = [module.Public_Subnets, module.SG]
}


#LB

module "LB" {
  source          = "./modules/LB"
  vpc_id          = module.VPC.vpc_id
  lb_security_gps = module.SG.lb_security_group
  ec2s_ids        = module.EC2.ec2s_ids
  lb_subnets      = module.Public_Subnets.subnets
  project         = var.project
  depends_on      = [module.EC2]
}