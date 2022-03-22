#!/bin/bash

DOMAIN_NAME=$1
SSL_TYPE=$2
FILE_PATH="/tmp"

function gen_ecc_ssl {
	local domain_name=$1
	local file_path=$2
	local ssl_key="${domain_name}.ecc.key"
	local ssl_crt="${domain_name}.ecc.crt"

	openssl ecparam -genkey -name prime256v1 -out $file_path/key.pem
	openssl req -new -sha256 -key $file_path/key.pem -out $file_path/csr.csr
	openssl req -x509 -sha256 -days 365 -key $file_path/key.pem -in $file_path/csr.csr -out $file_path/certificate.pem
	openssl req -in $file_path/csr.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"

	mv $file_path/key.pem $file_path/$ssl_key
	mv $file_path/certificate.pem $file_path/$ssl_crt
}

function gen_rsa_ssl {
	local domain_name=$1
	local file_path=$2
	local ssl_key="${domain_name}.rsa.key"
	local ssl_crt="${domain_name}.rsa.crt"

	# signed root crt
	openssl genrsa -des3 -out $file_path/RootCA.key 2048
	chmod 600 $file_path/RootCA.key
	openssl req -new -key $file_path/RootCA.key -out $file_path/RootCA.req
	openssl x509 -req -days 3650 -sha256 -extensions v3_ca -signkey $file_path/RootCA.key -in $file_path/RootCA.req -out $file_path/RootCA.crt
	# for security issue, remove root crt
	# rm -f $file_path/RootCA.req

	# create server side ssl request file
	openssl genrsa -out $file_path/ServerCert.key 2048
	openssl req -new -key $file_path/ServerCert.key -out $file_path/ServerCert.req
	# generate an uuid for this file
	echo 1000 > $file_path/RootCA.srl
	# signed server crt
	openssl x509 -req -days 1095 -sha256 -extensions v3_req -CA $file_path/RootCA.crt -CAkey $file_path/RootCA.key -CAserial $file_path/RootCA.srl -CAcreateserial -in $file_path/ServerCert.req -out $file_path/ServerCert.crt

	mv $file_path/ServerCert.key $file_path/$ssl_key
	mv $file_path/ServerCert.crt $file_path/$ssl_crt
}

function gen_ssl {
	local domain_name=$1
	local file_path=$2
	local ssl_type=$3
	if [ $ssl_type = "rsa" ]
	then
		echo "rsa"
		gen_rsa_ssl $DOMAIN_NAME $FILE_PATH
	elif [ $ssl_type = "ecc" ]
	then
		echo "ecc"
		gen_ecc_ssl $DOMAIN_NAME $FILE_PATH
	else
		echo "ssl type not support"
	fi
}

gen_ssl $DOMAIN_NAME $FILE_PATH $SSL_TYPE
