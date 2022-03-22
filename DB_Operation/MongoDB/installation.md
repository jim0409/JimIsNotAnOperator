# install mongo on centos7
1. 在centos7的yum專案管理下創建repo位置
```
cd /etc/yum.repos.d/
touch mongodb-org-3.2.repo
```

2. 將以下文字更新到`mongodb-org-3.2.repo`
> vi mongodb-org-3.2.repo
```
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc
```

3. 開始安裝
> yum update -y; yum -y install mongodb-org

4. 啟用mongo systemctl
> systemctl start mongod

