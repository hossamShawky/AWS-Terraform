variable "region" {
  default = "us-east-1"
}
variable "project" {
  default = "cloud_filestorage"
}
variable "user_bucket" {
  default = "userapibuckets3"
}

variable "lambda_runtime" {
  default = "python3.9"
}
variable "stage_name" {
  default = "prod"
}

variable "web_bucket" {
  default = "webapibuckets3"

}