terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "bucket001" {
  bucket = "bucketfernando001"

  tags = {
    Name        = "Bucket para Python"
    Environment = "Dev"
    ManagedBy   = "Fernando"
    UpdatedAT   = "2023-9-19"
  }
}