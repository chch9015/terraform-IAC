#create securit group for the alb

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.petclinic.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH from VPC"
    from_port        = 443
    to_port          = 443
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
    Name = "${var.envname}-alb-sg"
  }
}

#create target group
resource "aws_lb_target_group" "alb-tomcat-tg" {
  name     = "petclinic-tomcat-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.petclinic.id

 tags = {
    Name = "${var.envname}-tomcat-tg"
  }  

}

#target group attach to instance
resource "aws_lb_target_group_attachment" "attach-tg-tomcat" {
  target_group_arn = aws_lb_target_group.alb-tomcat-tg.arn
  target_id        = aws_instance.tomcat.id
  port             = 8080
}

#alb listerner to accept enduser ips
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb-1.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tomcat-tg.arn
  }
  }


#create alb
resource "aws_lb" "alb-1" {
  name               = "petclinic-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.tf_petclinic_pubsubnet.*.id
  enable_deletion_protection = false



 tags = {
    Name = "${var.envname}-alb"
  }
}
















