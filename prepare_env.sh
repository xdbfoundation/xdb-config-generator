#!/bin/bash

apt update && apt install -y curl wget unzip python3 python3-pip postgresql-client

snap install aws-cli --classic

DISTRO=$(lsb_release -cs)
 wget -qO - https://apt.stellar.org/SDF.asc | apt-key add -
 echo "deb https://apt.stellar.org ${DISTRO} stable" | tee -a /etc/apt/sources.list.d/SDF-stable.list
apt-get update && apt-get install -y stellar-core

cat <<EOF > /etc/systemd/system/stellar-core.service
[Unit]
Description=Stellar Core Service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
ExecStart=/usr/bin/stellar-core --conf /etc/stellar.cfg run

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable stellar-core.service

echo "Done. Don't forget to set AWS_DEFAULT_REGION"