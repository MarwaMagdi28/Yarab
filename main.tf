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

            # Update package lists
            sudo yum update -y

            # Install required dependencies
            sudo yum install -y wget curl git

            # Install Prometheus
            curl -s https://prometheus.io/prometheus-2.43.0.linux-amd64.tar.gz -o prometheus.tar.gz
            sudo tar -xzvf prometheus.tar.gz -C /usr/local/bin/
            sudo chown -R ec2-user:ec2-user /usr/local/bin/prometheus

            # Create a Prometheus configuration file
            sudo mkdir -p /etc/prometheus
            cat <<EOF > /etc/prometheus/prometheus.yml
            global:
              scrape_interval: 15s
              evaluation_interval: 15s
            scrape_configs:
              - job_name: local
                static_configs:
                  - targets: ['localhost:9090']
            EOF

            # Start Prometheus as a service
            sudo systemctl enable prometheus
            sudo systemctl start prometheus

            # Install Grafana
            curl -s https://grafana.com/releases/latest/grafana-server-linux-amd64.tar.gz -o grafana.tar.gz
            sudo tar -xzvf grafana.tar.gz -C /usr/local/bin/
            sudo chown -R ec2-user:ec2-user /usr/local/bin/grafana

            # Create a Grafana configuration file
            sudo mkdir -p /etc/grafana
            cat <<EOF > /etc/grafana/grafana.ini
            [server]
            root_url = http://localhost:3000
            [database]
            datasources = ["prometheus"]
            EOF

            # Start Grafana as a service
            sudo systemctl enable grafana-server
            sudo systemctl start grafana-server
            EOF
}
