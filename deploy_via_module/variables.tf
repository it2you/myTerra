variable "prefix" {
  default = "naumtest"
}
variable "region" {
  default = "ap-southeast-2"
}
variable "vpc_cidr"{
  default = "10.5.0.0/16"
}
variable "vpc_priv_subnets" {
  default = ["10.5.5.0/24", "10.5.7.0/24"]
}
variable "vpc_pub_subnets" {
  default = ["10.5.6.0/24", "10.5.8.0/24"]
}
variable "vpc_zones" {
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}
variable "instance_type" {
  default = "t2.micro"
}
