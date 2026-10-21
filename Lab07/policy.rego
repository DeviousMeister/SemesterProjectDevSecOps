package main

import rego.v1

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "aws_s3_bucket"
  not resource.change.after.tags.Project
  msg := "S3 buckets must have a Project tag set"
}