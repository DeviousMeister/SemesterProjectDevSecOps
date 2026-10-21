terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lab7_bucket" {
  bucket = "daboin_bucket_lab7"

  tags = {
    Project = "DevSecOps-Lab7"
  }
}
