
variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "node_volume_size" {
  default = 20
}
variable "endpoint_public_access" {
  default = true
}
variable "endpoint_public_access_cidrs" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable "addons" {
  type = list(object({
    name    = string
    version = optional(string)
  }))
  default = [
    { name = "vpc-cni" },
    { name = "coredns" },
    { name = "kube-proxy" },
    { name = "amazon-cloudwatch-observability" },
    { name = "aws-ebs-csi-driver" },
    { name = "eks-pod-identity-agent" }
  ]
}
