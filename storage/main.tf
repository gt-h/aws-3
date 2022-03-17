resource "random_id" "num" {
  byte_length = 2
}

resource "aws_s3_bucket" "b" {
  bucket        = "${var.client_name}-${random_id.num.dec}"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  tags = {
    Name = "${var.client_name}-bucket"
  }
}
