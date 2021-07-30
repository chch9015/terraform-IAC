#we are using the remote statefile for s3
#lock key for the dynamo DB


terraform {
  backend "s3" {
    bucket = "testate"
    key    = "myapp/1vpc/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraformstatelock"
  }
}