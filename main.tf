# Create VPC
resource "aws_vpc" "my_vpcsethu" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Myvpc24"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpcsethu.id
  tags = {
    Name = "Myigw24"
  }
}

# Create subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpcsethu.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Mysubnet24"
  }
}

# Create IAM user
resource "aws_iam_user" "my_uservpcofsethu" {
  name = "my_user"
}

# Attach IAM policy to user
resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.my_uservpcofsethu.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess" # Example policy, change to desired policy ARNN #Modify the access if needed
}

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
