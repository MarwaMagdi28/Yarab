terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-1" # Replace with your desired AWS region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-047d7c33f6e7b4bc4"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }

  user_data = <<-EOF
          #!/bin/bash
          # Update the system
          sudo yum update -y
          sudo yum install prometheus
          sudo systemctl start prometheus
          sudo systemctl enable prometheus
          EOF
}
