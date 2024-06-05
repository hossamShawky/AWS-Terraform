provider "aws" {
  region  = var.region
  profile = "test"
  default_tags {
    tags = {
      "Project" = var.project
    }
  }
}