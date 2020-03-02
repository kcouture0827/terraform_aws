variable "profile" {
  default = "default"
}
variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "tenancy" {
  default = "default"
}
variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}
variable "ec2_count" {
  default = "1"
}
variable "ami_id" {
  default = "ami-0a887e401f7654935"
}
variable "instance_type" {
  default = "t2.micro"
}
