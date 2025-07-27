
# Create an S3 Bucket
resource "aws_s3_bucket" "test22" {
  bucket = "test22"
  acl    = "private"
  tags = {
    Name = "test22"
  }
}

# Create another S3 Bucket
resource "aws_s3_bucket" "test23" {
  bucket = "test23"
  acl    = "private"
  tags = {
    Name = "test23"
  }
}
