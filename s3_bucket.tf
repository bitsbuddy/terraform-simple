resource "aws_s3_bucket" "rishi_test_bucket" {
  bucket = "rishi-test"
  acl    = "private"

  tags = {
    Name = "rishi-test-bucket"
  }
}