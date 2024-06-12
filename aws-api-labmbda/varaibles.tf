variable "region" {
  default = "us-east-1"
}
variable "project" {
  default = "apigateway"
}

variable "cidr_block" {
  default = "15.0.0.0/16"
}
variable "desired_count" {
  default = 2
}
