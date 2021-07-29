1)install the terraform and setup the path
2)install the aws cli and setup the aws configure
3)if more accounts use profile: keys will store in the user home directory
of .aws (config/credentials)

argument(input)/attribute(output)

==========================================
  terraform apply --var-file dev.tfvars
==========================================

here,by using terraform we are creating the VPC

provider: aws
region: mumbai
resource: vpc
cidr: 10.1.0.0/16
enable the dns = true

subnets
----------
public subnet = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
private subnet = ["10.1.3.0/24","10.1.4.0/24","10.1.4.0/24"]
data subnet = ["10.1.6.0/24","10.1.7.0/24","10.1.8.0/24"]

mainly use these commands to create 
---------------------------------------
terraform init
terraform plan
terraform apply
