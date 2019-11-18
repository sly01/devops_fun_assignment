provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "aerkoc-tfstate"
    key = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}