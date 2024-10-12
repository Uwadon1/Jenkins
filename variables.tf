variable "aws_region" {
  description = "The AWS region to deploy the infrastructure"
  type        = string
  default     = "us-east-1"
}


#VPC CIDR Block
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}


#Subnet CIDR Block
variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}


#Availability Zone Block
variable "availability_zone" {
  description = "The Availability Zone block for the subnet"
  type        = string
  default     = "us-east-1a"
}


#Ubuntu AMI ID
variable "ami_id" {
  description = "The AMI ID of the EC2 server"
  type        = string
  default     = "ami-005fc0f236362e99f"
}


#Instance ID
variable "instance_type_id" {
  description = "The Instance ID of your EC2 machine"
  type        = string
  default     = "t2.medium"
}