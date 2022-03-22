#!/bin/bash
# due to my workspace shift from ubuntu to centos7
# relevant environment duplicated setting is annoyed
# installation list
# 1. git/wget/curl/ab/nc/vim
# 2. docker/docker-compose
# 3. zsh/oh-my-zsh
# 4. change /etc/environment to support UTF-8 display
# 5. 

# pre-install pkg
sudo yum update -y
sudo yum install -y git wget vim curl httpd-tools nc vim

# install docker-related script
# set repo config
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# install docker-ce
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose;sudo chmod +x /usr/bin/docker-compose

# check out root user for zsh mode
sudo yum install zsh -y
sudo sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chsh -s /bin/zsh

# change env for UTF-8 display
echo << EOF >> /etc/environment
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOF
# sudo sed -i '1i LANG=en_US.utf-8' /etc/environment 
# sudo sed -i '2i LC_ALL=en_US.utf-8' /etc/environment 

