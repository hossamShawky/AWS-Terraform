variable "region" {
  default = "us-east-1"
}
variable "project" {
  default = "demo-fargate"
}
variable "account_number" {
  description = "Type Your AccountID,,,,"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "desired_count" {
  default = 2
}