module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.prefix
  cidr = var.vpc_cidr

  azs             = var.vpc_zones
  private_subnets = var.vpc_priv_subnets
  public_subnets  = var.vpc_pub_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
