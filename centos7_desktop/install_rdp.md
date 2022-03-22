# intro
install RDP on centos7
(*note: with pre-installed desktop on centos7)


# steps
1. sudo yum -y update
2. sudo yum install -y epel-release
3. sudo yum install -y xrdp
4. sudo systemctl enable xrdp
5. sudo systemctl start xrdp

# allow-firewall to access
1. sudo firewall-cmd --add-port=3389/tcp --permanent
2. sudo firewall-cmd --reload


... 安裝好以後，連不上...還在查是否有其他BUG


# refer:
- https://draculaservers.com/tutorials/install-xrdp-centos/
