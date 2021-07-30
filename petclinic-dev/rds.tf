#create securit group for the rds

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.bastion.id}"]
  }
    ingress {
    description      = "SSH from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.tomcat.id}"]
  }
    ingress {
    description      = "SSH from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.jenkins.id}"]
  }  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 tags = {
    Name = "${var.envname}-rds-sg"
  }
}





















# resource "aws_instance" "bastion" {
#   ami           = var.ami
#   instance_type = var.type
#   key_name = var.pem
#   vpc_security_group_ids = var.securitygroup


#   tags = {
#     Name = var.envname
#   }
# }