resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "s3-bucket-ketineniakhil-v1"
}

variable "users" {
  default = ["akhil", "ramu", "krishna"]
}

resource "aws_iam_user" "my_iam_user_1" {
  count = length(var.users)
  name  = var.users[count.index]
}