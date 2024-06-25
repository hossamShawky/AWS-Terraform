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

##4- IAM Role For Lambda

module "IAM" {
  source         = "./lambda"
  sns_arn        = module.SNS.sns_arn
  depends_on     = [module.SNS]
  main_bucket    = module.MainS3.bucket_name
  resized_bucket = module.Resized3.bucket_name
  project        = var.project

}