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

# Generate unique ID for bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "enterprise_bucket" {
  bucket = "dev-app-akhil-${random_id.bucket_id.hex}"  # Unique bucket name

  lifecycle {
    prevent_destroy = true  # Prevent accidental deletion
  }

  force_destroy = true  # Allows Terraform to delete bucket even if it contains objects

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "enterprise_bucket_lock" {
  name         = "dev_lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"  # Define primary key

  attribute {
    name = "LockID"
    type = "S"  # String type
  }

  point_in_time_recovery {
    enabled = true  # Optional: Enable PITR for data safety
  }

  tags = {
    Name        = "Dev Lock Table"
    Environment = "Development"
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.enterprise_bucket_lock.name
}


output "bucket_name" {
  value = aws_s3_bucket.enterprise_bucket.id
}
