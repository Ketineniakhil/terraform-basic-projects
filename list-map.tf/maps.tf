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

variable "users" {
  default = {
    "akhil" = "india"
  }
}

resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name = each.key
  tags = {
    country = each.value
  }
}