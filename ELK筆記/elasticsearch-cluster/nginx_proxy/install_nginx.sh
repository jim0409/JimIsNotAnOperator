#!/bin/bash

sudo yum update -y;sudo yum install -y nginx

# enable nginx
sudo systemctl enable nginx
