#!/bin/bash

# install java 8
yum update -y
yum install java-1.8.0-openjdk -y
yum install -y wget

# install Apache JMeter
wget http://apache.stu.edu.tw//jmeter/binaries/apache-jmeter-5.2.1.tgz

# Extract the files
tar -xf apache-jmeter-5.2.1.tgz

# write path into /bin
echo 'export JMETER_HOME=/root/apache-jmeter-5.2.1' >> ~/.bashrc
echo 'export PATH=$JMETER_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

