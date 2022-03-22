#!/bin/bash

# download yum-utils
sudo yum install -y yum-utils

# config docker-ce repo
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# yum install docker-ce
sudo yum install -y docker-ce docker-ce-cli containerd.io

# enable & start docker
sudo systemctl enable docker; sudo systemctl start docker

# download docker-compose
sudo yum install -y curl
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /bin/docker-compose
sudo chmod +x /bin/docker-compose