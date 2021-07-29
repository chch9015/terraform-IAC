# create the vpc
resource "aws_vpc" "petclinic" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.envname
  }
}

#subnets

resource "aws_subnet" "tf_petclinic_pubsubnet" {
  count = length(var.azs)
  vpc_id     = aws_vpc.petclinic.id
  availability_zone = element(var.azs,count.index) 
  cidr_block = element(var.pubsubnets,count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.envname}-pubsubnet-${count.index+1}"
  }
}

resource "aws_subnet" "tf_petclinic_prisubnet" {
  count = length(var.azs)
  vpc_id     = aws_vpc.petclinic.id
  availability_zone = element(var.azs,count.index) 
  cidr_block = element(var.prisubnets,count.index)

  tags = {
    Name = "${var.envname}-prisubnet-${count.index+1}"
  }
}

resource "aws_subnet" "tf_petclinic_datasubnet" {
  count = length(var.azs)
  vpc_id     = aws_vpc.petclinic.id
  availability_zone = element(var.azs,count.index) 
  cidr_block = element(var.datasubnets,count.index)

  tags = {
    Name = "${var.envname}-datasubnet-${count.index+1}"
  }
}


# igw and with in vpc
 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.petclinic.id

  tags = {
    Name = "${var.envname}-igw"
  }
}


# eip
resource "aws_eip" "natip" {
  vpc      = true
   tags = {
    Name = "${var.envname}-natip"
  }
}

#natgw in public subnet
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natip.id
  subnet_id     = aws_subnet.tf_petclinic_pubsubnet[0].id

  tags = {
   Name = "${var.envname}-natgw"
  }
}


#public route table

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
   Name = "${var.envname}-publicroute"
  }
}


resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
   Name = "${var.envname}-privateroute"
  }
}


resource "aws_route_table" "dataroute" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
   Name = "${var.envname}-dataroute"
  }
} 


#route table association

resource "aws_route_table_association" "pubsubassociation" {
  count = length(var.pubsubnets)
  subnet_id      = element(aws_subnet.tf_petclinic_pubsubnet.*.id,count.index)
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "prisubassociation" {
  count = length(var.prisubnets)
  subnet_id      = element(aws_subnet.tf_petclinic_prisubnet.*.id,count.index)
  route_table_id = aws_route_table.privateroute.id
}

resource "aws_route_table_association" "datasubassociation" {
  count = length(var.prisubnets)
  subnet_id      = element(aws_subnet.tf_petclinic_datasubnet.*.id,count.index)
  route_table_id = aws_route_table.dataroute.id
}







































































































































































































# resource "aws_subnet" "tf_petclinic_prisubnet" {
#   vpc_id     = aws_vpc.petclinic.id
#   cidr_block = var.prisubnets

#   tags = {
#     Name = var.envname_prisubnet
#   }
# }

# resource "aws_subnet" "tf_petclinic_datasubnet" {
#   vpc_id     = aws_vpc.petclinic.id
#   cidr_block = var.datasubnets

#   tags = {
#     Name = var.envname_datasubnet
#   }
# }