#Create a Terraform Provider Block

terraform {
  required_providers {
    aws = {

      source  = "hashicorp/aws"
      version = "~>5.68.0"

    }
  }
}


provider "aws" {

  region = var.aws_region # Select your desired region

}