#!/bin/bash

# download and install public signing key
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# create .repo extension for elastic.repo
sudo cat << EOF > /etc/yum.repos.d/elastic.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

# install kibana
sudo yum install -y kibana

# enable kibana
sudo systemctl enable kibana

# start kibana
# sudo systemctl start kibana

# check kibana status
# time sleep 1m # wait a min and check
# curl -I localhost:5601


