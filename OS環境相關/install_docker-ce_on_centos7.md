# intro
在centos7上安裝`docker`及`docker-compose`


# installation
```bash
# set repo config
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# install docker-ce
sudo yum install -y docker-ce docker-ce-cli containerd.io
```


# install docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose;sudo chmod +x /usr/bin/docker-compose
```

# refer:
- https://docs.docker.com/engine/install/centos/

