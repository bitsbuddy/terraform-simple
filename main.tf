# Specify the provider
provider "aws" {
  region = "us-east-1"  # Replace with your preferred AWS region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  # Replace with your preferred availability zone
  tags = {
    Name = "my-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-internet-gateway"
  }
}

# Create a Route Table and Associate it with the Subnet
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-route-table"
  }
}

resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Launch an EC2 Instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c02fb55956c7d316"  # Replace with an appropriate AMI ID for your region
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.my_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "my-instance"
  }

  # Optional: Key Pair for SSH access
  key_name = "my-key-pair"  # Replace with your existing key pair name
}

# Create an S3 Bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-rishi-xxxxx"  # Name of the S3 bucket (must be globally unique
  tags = {
    Name = "test-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket_ownership" {
  bucket = aws_s3_bucket.test_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "test_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.test_bucket_ownership]
  bucket = aws_s3_bucket.test_bucket.id
  acl    = "private"
}

# Outputs
output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "s3_bucket_name" {
  value = aws_s3_bucket.test_bucket.bucket
}
