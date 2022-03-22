# intro
如何在 VM 上安裝資料庫


# MySQL 5.7
### installation and change root password to P@ssw0rd0409
```shell
# 1. 安裝 yum-utils 套件; 需要使用到 yum-config-manager 指令
sudo yum install yum-utils -y

# 2. 安裝對應套件時會自動加入 MySQL 的 Yum 源; 此 Yum 源已經將 MySQL 眾多軟體、眾多版本的套件都內含了
sudo yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm -y

# 3. 安裝 MySQL 5.7
# 1. 停用 MySQL 8.0 的 Yum 源，並啟用 MySQL 5.7 的 Yum 源
sudo yum-config-manager --disable mysql80-community
sudo yum-config-manager --enable mysql57-community

# 檢查是否已經啟用 MySQL Yum 源是否為 5.7，如果是要安裝 8.0 則不需要檢查
# sudo yum repolist enabled | grep "mysql.*-community.*"

# 生成一個要置換 mysql root 帳號密碼的 sql file，並且賦予 root 使用者所有的權限
# 備註: 這邊 root 只能在本地操作 ...
cat <<EOF > /tmp/mypwd.sql
alter user 'root'@'localhost' identified by '1qaz!QAZ'; 
flush privileges;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '1qaz!QAZ';
EOF

# 安裝 MySQL
sudo yum install mysql-community-server -y 

# 啟動 MySQL 服務
sudo systemctl start mysqld

# 啟用 MySQL，讓開機時自動啟動 MySQL 服務
sudo systemctl enable mysqld

# 檢視原始 MySQL 的預設密碼
# sudo grep 'temporary password' /var/log/mysqld.log
# 取得臨時密碼，置換 mysql 密碼
str=`sudo grep 'temporary password' /var/log/mysqld.log|cut -d" " -f 11`; mysql --connect-expired-password -u root -p$str < /tmp/mypwd.sql
rm /tmp/mypwd.sql
```


<!-- 以下指令只能在 terminal 做 -->
### Create new database and grant privillege to usr
```sql
CREATE DATABASE morse;
CREATE USER 'morse'@'%' IDENTIFIED BY '1qaz!QAZ';
GRANT ALL PRIVILEGES ON `morse`.* TO 'morse'@'%';
-- GRANT SELECT, INSERT, UPDATE, DELETE ON `morse`.* TO 'morse'@'%';
```


### Drop user
```sql
DROP USER 'morse'@'*';
```



# refer:
<!-- <install mysql> -->
- https://ithelp.ithome.com.tw/articles/10214666
<!-- create new user -->
- https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
