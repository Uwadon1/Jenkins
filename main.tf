# Create the VPC Block
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    name = "devops-group-6"
  }
}

# Create the Subnet(s)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    name = "devops-group-6"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    name = "devops-group-6"
  }
}

# Create Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    name = "devops-group-6"
  }
}

# Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security Groups
resource "aws_security_group" "josh-sg" {
  vpc_id = aws_vpc.my_vpc.id # Ensure the security group is created in the same VPC

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "devops-group-6"
  }
}

# Generate a new private key
resource "tls_private_key" "terraform_kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair using the public key generated above
resource "aws_key_pair" "my_terraform_kp" {
  key_name   = "terraform-kp" # New Key Pair Name
  public_key = tls_private_key.terraform_kp.public_key_openssh
}

# To create a file or folder to save your Private Key
resource "local_file" "terraform_kp" {
  content  = tls_private_key.terraform_kp.private_key_pem
  filename = "terraform-kp.pem" # Save as a .pem file
}

# Create EC2 Instance with NGINX installation via user_data
resource "aws_instance" "my_nginx_server" {
  depends_on = [aws_security_group.josh-sg, aws_subnet.public_subnet]

  ami                         = var.ami_id # Amazon Ubuntu AMI
  instance_type               = var.instance_type_id
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.josh-sg.id]
  key_name                    = "terraform-kp"
  associate_public_ip_address = true
  tags = {
    name = "devops-group-6"
  }

  # Userdata script to update packages, install Nginx, and set custom content
  user_data_replace_on_change = true

  user_data = <<EOF
#!/bin/bash

# Stop script on error
set -e

# Update the package list and install Nginx in one step
apt-get update -y && apt-get install nginx -y

# Start and enable Nginx service
systemctl start nginx
systemctl enable nginx

# Write a custom HTML page for testing
echo "<html><body><h1>Welcome to my first NGINX Ubuntu server</h1></body></html>" > /var/www/html/index.html

# Indicate that the script has completed successfully
echo "User Data Script Completed"
EOF

}
