#!/bin/bash

function installation {
	sudo yum update -y
	sudo yum install -y httpd mod_ssl
}

function remove_origin_config {
	sudo rm /etc/httpd/conf.d/welcome.conf

}

function add_reverse_proxy_config {
sudo cat << EOF /etc/httpd/conf.d/reverse_proxy.conf
ProxyPass / http://demo.testfire.net/
ProxyPassReverse / http://demo.testfire.net/
EOF
}

function add_forward_proxy_config {
sudo cat << EOF /etc/httpd/conf.d/forward_proxy.conf
ProxyRequests On
ProxyVia On
SSLProxyEngine On

<Proxy *>
    Order deny,allow
    Deny from all
    # Allow from IP/CIDR ... e.g. 123.123.213.0/24 132.231.123.123
    Allow from all
</Proxy>
EOF
}


local arg=$1

if [ $arg = "proxy" ]
then
	add_forward_proxy_config
elif [ $arg = "reverse_proxy" ]
then
	add_reverse_proxy_config
else
	echo "no such command"
fi

# check with curl command
# https_proxy=http://10.200.12.23:80 curl https://www.google.com/ 
# http_proxy=http://10.200.12.23:80 curl http://demo.testfire.net/
