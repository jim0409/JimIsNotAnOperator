#!/bin/bash

#######################################

dirTmpdir="/data/db/mysql/tmpdir"
dirData="/data/db/mysql/data"

dirLog="/data/logs/mysql"
dirBinlog="/data/logs/mysql/mysql-bin"
dirRelaylog="/data/logs/mysql/relaylog"
dirSlowlog="/data/logs/mysql/slowlog"
dirAuditlog="/data/logs/mysql/auditlog"

dirRun="/var/run/mysqld/"

serverID=$(hostname -I | awk '{print $1}' | sed 's/\.//g')
host=$(hostname -s)

# remove mariadb
mariadbRpm=$(rpm -qa | grep mariadb)
for ma in ${mariadbRpm}
do
    rpm -e --nodeps ${ma}
done

#######################################

# get mysql 5.7.25 rpm package
rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-common-5.7.25-1.el7.x86_64 \
            mysql-community-client-5.7.25-1.el7.x86_64 \
            mysql-community-libs-5.7.25-1.el7.x86_64 \
            mysql-community-server-5.7.25-1.el7.x86_64 \
            mysql-community-libs-compat-5.7.25-1.el7.x86_64

# create & change mysql relevant folder policy
mkdir -p $dirTmpdir \
         $dirData \
         $dirBinlog \
         $dirRelaylog \
         $dirSlowlog \
         $dirAuditlog \
         $dirRun

chown -R mysql. /data/db/mysql/ $dirTmpdir $dirData $dirLog /var/lib/mysql/ $dirRun

#######################################

# initialize mysql data
# if there is an error while initializing do remove the /data/db/mysql/data/* content
# ref: https://stackoverflow.com/a/37646793
mysqld --defaults-file=/etc/my.cnf --initialize-insecure --user=mysql && sleep 5
sed -i "s|5000|65535|g" /usr/lib/systemd/system/mysqld.service
systemctl daemon-reload
# systemctl start mysqld
# systemctl enable mysqld

