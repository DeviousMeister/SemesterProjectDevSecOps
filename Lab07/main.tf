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
  # checkov:skip=CKV_AWS_18:Access logging not required for this lab
  # checkov:skip=CKV_AWS_144:Cross-region replication not required for this lab
  # checkov:skip=CKV2_AWS_62:Event notifications not required for this lab
  bucket = "daboin-bucket-lab7"

  tags = {
    Project = "DevSecOps-Lab7"
  }
}

resource "aws_s3_bucket_versioning" "lab7_bucket" {
  bucket = aws_s3_bucket.lab7_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "lab7_bucket" {
  bucket = aws_s3_bucket.lab7_bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "lab7_key" {
  # checkov:skip=CKV2_AWS_64:Default key policy is sufficient for this lab
  description = "Lab07 S3 encryption key"
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lab7_bucket" {
  bucket = aws_s3_bucket.lab7_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = aws_kms_key.lab7_key.arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lab7_bucket" {
  bucket = aws_s3_bucket.lab7_bucket.id
  depends_on = [aws_s3_bucket_versioning.lab7_bucket]

  rule {
    id = "expire-old-versions"
    status = "Enabled"
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}