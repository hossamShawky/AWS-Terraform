variable "project" {

}

variable "vpc_id" {

}


variable "type" {

}

variable "nat" {
  default = ""
}

variable "destination" {

}

variable "igw" {

}

variable "cidrs" {

}
variable "availability_zones" {
  type = list(string)
}