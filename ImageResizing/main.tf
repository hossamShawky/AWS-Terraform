##1-Module SNS
module "SNS" {
  source  = "./SNS"
  project = var.project
  profile = "demos"
}
##2 Main S3

module "MainS3" {
  source  = "./S3"
  project = var.project
  type    = "main"
}

##3 Resized S3

module "Resized3" {
  source  = "./S3"
  project = var.project
  type    = "resized"
}