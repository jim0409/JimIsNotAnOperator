CREATE USER jim;
GRANT REPLICATION SLAVE on *.* to 'jim'@'192.18.0.%' IDENTIFIED by 'jim';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS test_db;