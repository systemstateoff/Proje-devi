 #--- AWS ALTYAPISI ---
module "aws_vpc" {
  source               = "./aws_terraform/modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "aws_compute" {
  source               = "./aws_terraform/modules/compute"
  vpc_id               = module.aws_vpc.vpc_id
  public_subnet_ids    = module.aws_vpc.public_subnet_ids
  private_subnet_ids   = module.aws_vpc.private_subnet_ids
}

# --- GCP ALTYAPISI ---
module "gcp_network" {
  source      = "./gcp_terraform/modules/network"
  gcp_region  = var.gcp_region  
  subnet_cidr = var.subnet_cidr
}

module "gcp_compute" {
  source    = "./gcp_terraform/modules/compute"
  zone      = var.zone
  subnet_id = module.gcp_network.subnet_id
}