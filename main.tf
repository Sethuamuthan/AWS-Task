
# Create an IAM Role
resource "aws_iam_role" "example_role" {
  name = "example_rolesethu"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Create an IAM Instance Profile
resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "example_instance_profile"
  role = aws_iam_role.example_role.name
}

# Create the EC2 instance with the IAM instance profile
resource "aws_instance" "example" {
  ami                  = "ami-03f4878755434977f"
  instance_type        = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.example_instance_profile.name

  tags = {
    Name = "Myserver"
  }
}


# Create an IAM Role
resource "aws_iam_role" "s3_sethu2_role" {
  name = "s3_sethu2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "s3.amazonaws.com"
      }
    }]
  })
}

# Create the S3 bucket
resource "aws_s3_bucket" "sethus3_bucket" {
  bucket = "my-tf-test-bucketofsethu"

  tags = {
    Name = "MyBucket24"
  }
}

# Attach a policy to the S3 bucket allowing access to the IAM role
resource "aws_s3_bucket_policy" "sethus3_bucket_policy" {
  bucket = aws_s3_bucket.sethus3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = aws_iam_role.s3_sethu2_role.arn # Corrected role reference
      },
      Action = "s3:*",
      Resource = [
        "${aws_s3_bucket.sethus3_bucket.arn}",
        "${aws_s3_bucket.sethus3_bucket.arn}/*"
      ]
    }]
  })
}
