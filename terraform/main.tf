provider "aws" {
  region = "${var.aws_region}"
}

terraform {
  backend "s3" {
    bucket = "aerkoc-tfstate"
    key = "terraform/"
    region = "us-east-1"
  }
}