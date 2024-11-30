# create a vpc 
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "hskvpc"
  }
}

# create a pub subnet in 1a availability zone
resource "aws_subnet" "mysub1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
map_public_ip_on_launch = true
tags = {
  Name="hskpubsub1"
}
}

# create a pub subnet in 1b availability zone
resource "aws_subnet" "mysub2" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "hsk privsub"
  }
}

#create a igw for giving data aceess to vpc to subnets
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "hskigw"
  }
}

# create a route table and associate it with public subnets
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
   cidr_block = "0.0.0.0/0"
   gateway_id =aws_internet_gateway.myigw.id
  }

 tags = {
   Nmae = "hskrt"
 }

}

# associate the public subnet with route table
resource "aws_route_table_association" "pubsubassociate1" {
 subnet_id = aws_subnet.mysub1.id
 route_table_id = aws_route_table.myrt.id 

}
# associate the priv subnet with route table
resource "aws_route_table_association" "pubsubassociate2" {
 subnet_id = aws_subnet.mysub2.id
 route_table_id = aws_route_table.myrt.id 

}


# sg group allowing sg group port80 and ssh port22 trafic
resource "aws_security_group" "pubsg" {
  vpc_id = aws_vpc.myvpc.id
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port =22
    to_port = 22
    protocol = "tcp"
  }

   ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  tags = {
     Name = "pubsg"
  }
}

# Create 1st EC2 Instance
resource "aws_instance" "myser" {
  ami             = "ami-0fcc0bef51bad3cb2"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.mysub1.id
  key_name        = "euwest1keypair"
  vpc_security_group_ids   = [aws_security_group.pubsg.id] 
  tags = {
    Name = "hskserv"
  }
}

# created ec2 2nd instance 
resource "aws_instance" "myser2" {
  ami = "ami-0fcc0bef51bad3cb2"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.mysub2.id
  key_name        = "euwest1keypair"
  vpc_security_group_ids = [aws_security_group.pubsg.id]
  tags = {
    Name = "hskprivser"
  }
}


# Allocate Elastic IP
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Create the NAT Gateway
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.mysub1.id  # Replace with your public subnet ID
}

