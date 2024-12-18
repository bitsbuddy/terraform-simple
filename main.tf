
# Create an S3 Bucket
resource "aws_s3_bucket" "rishi_test_bucket" {
  bucket = "rishi-test"  # Name of the S3 bucket (must be globally unique)
  tags = {
    Name = "rishi-test-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "rishi_test_bucket_ownership" {
  bucket = aws_s3_bucket.rishi_test_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "rishi_test_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.rishi_test_bucket_ownership]
  bucket = aws_s3_bucket.rishi_test_bucket.id
  acl    = "private"
}
