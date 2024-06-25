##1-Module SNS
module "SNS" {
  source  = "./SNS"
  project = var.project
  profile = "demos"
}