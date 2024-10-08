#!/bin/bash
#!Install Prometheus
sudo yum update -y
sudo adduser --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
cd /tmp/
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-amd64.tar.gz
tar -xvf prometheus-2.54.1.linux-amd64.tar.gz
cd prometheus-2.54.1.linux-amd64
sudo mv console* /etc/prometheus
sudo mv prometheus.yml /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus
sudo mv prometheus /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
cat <<EOF > /etc/systemd/system/prometheus.service
      [Unit]
      Description=Prometheus

      [Service]
      User=prometheus
      Group=prometheus
      Type=simple
      ExecStart=/usr/local/bin/prometheus\
          --config.file=/etc/prometheus/prometheus.yml\
          --storage.tsdb.path /var/lib/prometheus\
          --web.console.templates=/etc/prometheus/console\
          --web.console.libraries=/etc/prometheus/console_libraries\

      [Install]
      WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

sudo yum update
sudo yum install wget curl git
sudo sudo yum install -y https://dl.grafana.com/enterprise/release/grafana-enterprise-11.2.2-1.x86_64.rpm
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

