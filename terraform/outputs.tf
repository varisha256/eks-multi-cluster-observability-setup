
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "platform_cluster_name" {
  value = module.eks_platform.cluster_name
}

output "workload_cluster_name" {
  value = module.eks_workload.cluster_name
}
