#create securit group for the bastion

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 tags = {
    Name = "${var.envname}-bastion-sg"
  }
}


#creating a key pair
resource "aws_key_pair" "cherry" {
  key_name   = "cherry-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQJIjXb1aTvhqtfm3AMKfbe6uAbuw6eZCZcCEm4SvfphRHbF3Jx2Z9cfgn+dTvx5vWcxTrL2ctu5uUpLv4NTB388W7QvbiItIOIGt3vRIpJZ1G8BO5YFwoVWTbkm0pdAte8oep/KF7qD7VP1RhFSqa1f3wZA/kF/cd1s7tMq8+SJtSnxRqxvuiNVP/aEogt+05+o/Y4lwlOAfwOUYJ99AeH0Nl/MCbSf/Ey8VAc3piJhH9xTBkCrN9Jfh0fBHYnUYnssgPl7zHwBvtOaXdJ/UmH1vbFGG7u7ZdoD2ZaePkYL7/89UIpVnZ/QsBmp34zSLxxsGN48jaP794kD7bM499 imported-openssh-key"
  }

#creating aws ec2 instance

resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.type
  key_name = aws_key_pair.cherry.id
  subnet_id = aws_subnet.tf_petclinic_pubsubnet[0].id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]


 tags = {
    Name = "${var.envname}-bastion"
  }
}




