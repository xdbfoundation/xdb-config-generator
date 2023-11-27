#!/bin/bash

set -e

if [ -z "$AWS_DEFAULT_REGION" ]; then
    echo "AWS_DEFAULT_REGION is not set. It is required to set this variable!"
    exit 1
else
    echo "AWS_DEFAULT_REGION is set to $AWS_DEFAULT_REGION."
fi

apt update && apt install -y curl wget unzip python3 python3-pip postgresql-client

snap install aws-cli --classic

pip3 install -r requirements.txt

read -p "Node Home Domain: " home_domain
read -p "Node Seed: " node_seed
read -p "Node Name: " node_name

python3 generator.py $home_domain $node_seed $node_name > /etc/stellar.cfg
hostname $node_name

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
ExecStart=/usr/bin/stellar-core --conf /etc/xdbchain.cfg run

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable stellar-core.service

echo "Done."
