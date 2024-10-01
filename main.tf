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
            sudo yum update -y
            sudo yum install -y wget curl git
            curl -s https://prometheus.io/prometheus-2.43.0.linux-amd64.tar.gz -o prometheus.tar.gz
            sudo tar -xzvf prometheus.tar.gz -C /usr/local/bin/
            sudo chown -R ec2-user:ec2-user /usr/local/bin/prometheus
          EOF
}
