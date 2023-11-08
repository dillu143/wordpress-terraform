provider "aws" {
  region     = "us-east-1"
  access_key = "AKIATNKTUDKECNAGNAHIONF6MX"
  secret_key = "Kk35QejUBEyBp6uEk4a6X2RiY+8t/Hmg0rOOicgpoJvyJ"
}
#################################
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "mini-project-vpc"
  }
}

#################################	
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

#################################
resource "aws_subnet" "pub_sub_1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  cidr_block              = "10.0.1.0/24"
  tags = {
    Name = "pub-ser-1-zn-A"
  }
}

resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-route-1-zn-A"
  }
}
resource "aws_route_table_association" "pub_ass" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.pub_route.id
}

##################################
resource "aws_key_pair" "key_pair" {
  key_name   = "key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "key-pair"
}

#####################################
resource "aws_security_group" "security" {
  name        = "security-a"
  description = "Allow the tcp"
  vpc_id      = (aws_vpc.vpc.id)

  ingress {
    description = "Tcp from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "pub-sec-A"
  }
}

#####################################
resource "aws_instance" "ec2-a" {
  ami                         = "ami-06aa3f7caf3a30282"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  subnet_id                   = aws_subnet.pub_sub_1.id
  key_name                    = aws_key_pair.key_pair.id
  tags = {
    Name = "pub-zn-a"
  }
  vpc_security_group_ids = [aws_security_group.security.id]
  user_data              = file("us-data.sh")
}
