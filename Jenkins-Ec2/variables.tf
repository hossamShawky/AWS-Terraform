variable "region" {
  default = "us-east-1"
}
variable "project" {
  default = "jenkins"
}
variable "type" {
  default = "t2.micro"
}

variable "cidr_block" {
  default = "20.0.0.0/16"
}
variable "subnet_cidr" {
  default = "20.0.2.0/24"
}