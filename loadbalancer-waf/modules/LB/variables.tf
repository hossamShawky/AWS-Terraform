variable "project" {

}

variable "vpc_id" {

}
variable "lb_security_gps" {

}

variable "lb_subnets" {

}
variable "port" {
  default = "80"
}


variable "protocol" {
  default = "HTTP"
}

variable "ec2s_ids" {

  type = list(string)
}