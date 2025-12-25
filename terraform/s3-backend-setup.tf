# # Run this once to create the S3 bucket for remote state
# # aws s3 mb s3://eks-multi-cluster-terraform-state --region us-west-2
# # aws s3api put-bucket-versioning --bucket eks-multi-cluster-terraform-state --versioning-configuration Status=Enabled

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "eks-multi-cluster-terraform-state"
# }

# resource "aws_s3_bucket_versioning" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
#   bucket = aws_s3_bucket.terraform_state.id

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }