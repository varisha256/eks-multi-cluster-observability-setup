
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azs      = var.azs
}

module "eks_platform" {
  source           = "./modules/eks"
  cluster_name     = "platform-eks"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_platform_subnet_ids
  
  endpoint_public_access = true
  endpoint_public_access_cidrs = ["<YOUR_IP>"]  # Restrict to your IP
}

module "eks_workload" {
  source           = "./modules/eks"
  cluster_name     = "workload-eks"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_workload_subnet_ids
  
  endpoint_public_access = true
  endpoint_public_access_cidrs = ["<YOUR_IP>"]  # Restrict to your IP
}
