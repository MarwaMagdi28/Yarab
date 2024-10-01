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
  # Add other AWS provider configuration as needed
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-047d7c33f6e7b4bc4"
  instance_type = "t2.micro"

  tags = {
    Name = "MyEC2Instance"
  }

    user_data = <<-EOF
            #!/bin/bash
            sudo apt-get update
            sudo apt-get install ansible -y
            sudo systemctl start ansible
            EOF
}