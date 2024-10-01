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

          # Create a Prometheus user
          sudo useradd --no-create-home --shell /bin/false prometheus

          # Create necessary directories
          sudo mkdir /etc/prometheus
          sudo mkdir /var/lib/prometheus

          # Download Prometheus
          cd /tmp
          curl -LO https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz

          # Extract Prometheus
          tar -xvf prometheus-2.41.0.linux-amd64.tar.gz
          cd prometheus-2.41.0.linux-amd64

          # Move binaries to /usr/local/bin
          sudo mv prometheus /usr/local/bin/
          sudo mv promtool /usr/local/bin/

          # Move configuration files
          sudo mv prometheus.yml /etc/prometheus/
          sudo mv consoles /etc/prometheus/
          sudo mv console_libraries /etc/prometheus/

          # Set ownership
          sudo chown -R prometheus:prometheus /etc/prometheus
          sudo chown -R prometheus:prometheus /var/lib/prometheus

          # Create a systemd service file for Prometheus
          sudo tee /etc/systemd/system/prometheus.service <<EOF
          [Unit]
          Description=Prometheus
          Wants=network-online.target
          After=network-online.target

          [Service]
          User=prometheus
          Group=prometheus
          Type=simple
          ExecStart=/usr/local/bin/prometheus \
            --config.file /etc/prometheus/prometheus.yml \
            --storage.tsdb.path /var/lib/prometheus/ \
            --web.console.templates=/etc/prometheus/consoles \
            --web.console.libraries=/etc/prometheus/console_libraries

          [Install]
          WantedBy=multi-user.target
          EOF

          # Reload systemd and start Prometheus
          sudo systemctl daemon-reload
          sudo systemctl start prometheus
          sudo systemctl enable prometheus

          EOF
}
