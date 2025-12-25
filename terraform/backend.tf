terraform {
  backend "s3" {
    bucket = "eks-multi-cluster-terraform-state"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    
    # Optional: Enable state locking with DynamoDB
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
  }
}