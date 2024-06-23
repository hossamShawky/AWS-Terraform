provider "aws" {
  region  = var.region
  profile = "eks"
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}