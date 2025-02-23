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

# Get latest Amazon Linux 2 AMI dynamically
data "aws_ami" "aws_linux_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Get all default subnets within the VPC
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
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

resource "aws_security_group" "elb_securiy_group" {
  name   = "elb_security_group"
  vpc_id = aws_default_vpc.default.id  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#load blancer

resource "aws_elb" "elb" {
  name = "elb"
  subnets = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_securiy_group.id]
  instances = values(aws_instance.http_server).*.id
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"

  }
}

# Launch EC2 Instances in all default subnets
resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.aws_linux_latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"  
  vpc_security_group_ids = [aws_security_group.http_aws_group.id]
  
  # Iterate over all default subnets and launch an instance in each
  for_each  = toset(data.aws_subnets.default_subnets.ids)
  subnet_id = each.value

  tags = {
    Name = "HTTP Server_${each.value}"
  }
}

# Outputs
output "aws_security_group_details" {
  value = aws_security_group.http_aws_group
}

output "aws_instance_det" {
  value = values(aws_instance.http_server).*.id
}

output "elb_details" {
  value = aws_elb.elb
}
