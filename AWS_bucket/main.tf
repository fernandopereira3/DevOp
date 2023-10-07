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

# resource "aws_s3_bucket" "bucket001" {
#   bucket = "bucketfernando001"

#   tags = {
#     Name        = "Bucket para Python"
#     Environment = "Dev"
#     ManagedBy   = "Fernando"
#     UpdatedAT   = "2023-9-19"
#   }
# }

resource "aws_transfer_server" "example" {
  endpoint_type = "VPC"

  endpoint_details {
    subnet_ids = [aws_subnet.subnet_1.id]
    vpc_id     = aws_vpc.default.id
  }

  protocols   = ["FTP", "FTPS"]
  certificate = aws_acm_certificate.example.arn

  identity_provider_type = "API_GATEWAY"
  url                    = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_resource.example.path}"
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "us-west-2"
}

resource "aws_default_vpc" "default" {
  
}