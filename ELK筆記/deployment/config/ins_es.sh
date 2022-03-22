#!/bin/bash

# download and install public signing key
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# create .repo extension for elastic.repo
sudo bash -c 'cat << EOF > /etc/yum.repos.d/elastic.repo
[elastic-7.x]
name=Elastic repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF'

# install elasticsearch
sudo yum install -y elasticsearch

# enable elasticsearch
sudo systemctl enable elasticsearch 
