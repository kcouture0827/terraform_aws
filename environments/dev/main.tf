provider "aws" {
  profile = var.profile
  region  = var.region
}

module "dev_vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  tenancy     = var.tenancy
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

#module "dev_public_ec2" {
#  source        = "../../modules/ec2"
#  ec2_count     = var.ec2_count
# ami_id        = var.ami_id
#  instance_type = var.instance_type
#  subnet_id     = module.dev_vpc.public_subnet_id
#}
