provider "aws" {
  region  = var.region
  profile = "demos"
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}