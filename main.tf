provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
module "my_ec2" {
  source = "./modules/ec2"
}