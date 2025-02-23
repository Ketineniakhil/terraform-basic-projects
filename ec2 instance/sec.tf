terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Get default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
#get ami dynamic
data "aws_ami" "aws-linux-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
# Get default subnet 
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"  
  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

# Create Security Group
resource "aws_security_group" "http_aws_group" {
  name   = "http_aws_group"
  vpc_id = aws_default_vpc.default.id  

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 Instance in the default subnet
resource "aws_instance" "http_server" {
  #ami                    = "ami-05b10e08d247fb927"
  #dynamical way.
  ami                    = data.aws_ami.aws-linux-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"  
  vpc_security_group_ids = [aws_security_group.http_aws_group.id]
  subnet_id              = aws_default_subnet.default_az1.id  

  tags = {
    Name = "HTTP Server"
  }
}

# Outputs
output "aws_security_group_details" {
  value = aws_security_group.http_aws_group
}

output "aws_instance" {
  value = aws_instance.http_server
}
