output "dev_vpc_id" {
  value = aws_vpc.petclinic.id
}

output "dev_vpc_cidr_block" {
  value = aws_vpc.petclinic.cidr_block
}


output "dev_vpc_arn" {
  value = aws_vpc.petclinic.arn
}