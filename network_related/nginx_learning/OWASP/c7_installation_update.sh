#!/bin/bash
 
# https://github.com/SpiderLabs/ModSecurity/wiki/Reference-Manual-%28v2.x%29#manually-installing-modsecurity-module-on-nginx
yum install epel-release -y
yum update -y
yum install -y gcc-c++ flex bison yajl yajl-devel curl-devel curl GeoIP-devel doxygen zlib-devel pcre pcre-devel libxml2 libxml2-devel autoconf automake lmdb-devel ssdeep-devel ssdeep-libs lua-devel libmaxminddb-devel git autoconf automake git libtool wget yum-utils make automake gcc gcc-c++ kernel-devel openssl openssl-devel geoip lmdb-libs libpciaccess-devel device-mapper-devel pkgconfig zlib-devel
yum groupinstall "Development Tools" "Development Libraries" -y
yum group install "Development Tools" -y

########## some replace pkgs noted as below #################
# apt-utils -> yum-utils
# build-essential -> make automake gcc gcc-c++ kernel-devel
# libcurl4-openssl-dev -> openssl openssl-devel
# libgeoip-dev -> geoip
# liblmdb-dev -> lmdb-libs
# libyajl-dev -> libpciaccess-devel device-mapper-devel
# pkgconf -> pkgconfig
# zlib1g-dev -> zlib-devel



# download ModSecurity
# https://github.com/SpiderLabs/ModSecurity/issues/2254#issuecomment-581077815
git clone --depth 1 -b v3.0.4 --single-branch https://github.com/SpiderLabs/ModSecurity /opt/ModSecurity
cd /opt/ModSecurity/
git submodule init && git submodule update
./build.sh
./configure
make && make install

# download ModSecurity-nginx connector
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /opt/ModSecurity-nginx
wget http://nginx.org/download/nginx-1.17.5.tar.gz -O /opt/nginx-1.17.5.tar.gz
tar -xvf /opt/nginx-1.17.5.tar.gz -C /opt
cd /opt/nginx-1.17.5/
./configure --with-compat --add-dynamic-module=/opt/ModSecurity-nginx   
make && make install


# add extra import pkg into nginx.conf
sed  -i '11i load_module /usr/local/nginx/modules/ngx_http_modsecurity_module.so;' /usr/local/nginx/conf/nginx.conf


# add modsec_config and CRS
mkdir -p /usr/local/nginx/conf/modsec
wget https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended -O /usr/local/nginx/conf/modsec/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /usr/local/nginx/conf/modsec/modsecurity.conf
cp /opt/ModSecurity/unicode.mapping /usr/local/nginx/conf/modsec # copy unicode map into folder


# Add modsec_main.conf for `Include Files`
cat << EOF > /usr/local/nginx/conf/modsec/main.conf
# Include the recommended configuration
Include /usr/local/nginx/conf/modsec/modsecurity.conf
# A test rule
SecRule ARGS:testparam "@contains test" "id:1234,deny,log,status:403"
EOF


# add extra import pkg into nginx.conf
sed  -i '46i modsecurity_rules_file /usr/local/nginx/conf/modsec/main.conf;' /usr/local/nginx/conf/nginx.conf
sed  -i '46i modsecurity on;' /usr/local/nginx/conf/nginx.conf


# install Core Rule Set for nginx
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/local/owasp-modsecurity-crs

# create config
cp /usr/local/owasp-modsecurity-crs/crs-setup.conf.example /usr/local/owasp-modsecurity-crs/crs-setup.conf

# modify crs-setup.conf
sed -i 's/SecDefaultAction "phase:1,log,auditlog,pass"/#SecDefaultAction "phase:1,log,auditlog,pass"/g' /usr/local/owasp-modsecurity-crs/crs-setup.conf
sed -i 's/SecDefaultAction "phase:2,log,auditlog,pass"/#SecDefaultAction "phase:2,log,auditlog,pass"/g' /usr/local/owasp-modsecurity-crs/crs-setup.conf
sed -i 's/#.*SecDefaultAction "phase:1,log,auditlog,deny,status:403"/SecDefaultAction "phase:1,log,auditlog,deny,status:403"/g' /usr/local/owasp-modsecurity-crs/crs-setup.conf
sed -i 's/# SecDefaultAction "phase:2,log,auditlog,deny,status:403"/SecDefaultAction "phase:2,log,auditlog,deny,status:403"/g' /usr/local/owasp-modsecurity-crs/crs-setup.conf

cp /usr/local/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
cp /usr/local/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example /usr/local/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf

# cat << EOF >> /tmp/test.log ; insert config into main.conf
cat << EOF >> /usr/local/nginx/conf/modsec/main.conf
include /usr/local/owasp-modsecurity-crs/crs-setup.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf
Include /usr/local/owasp-modsecurity-crs/rules/REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-910-IP-REPUTATION.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-912-DOS-PROTECTION.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-913-SCANNER-DETECTION.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
include /usr/local/owasp-modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-950-DATA-LEAKAGES.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-980-CORRELATION.conf
include /usr/local/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
EOF


# start nginx
/usr/local/nginx/sbin/nginx

# test config valid or not ... any extra parameter would be forbidden
curl -D - http://localhost/foo?testparam=thisisatestofmodsecurity

# test sql injection
curl -D - http://localhost/?id='1 and 1=1'

# test xss injection
curl -D - http://localhost/?input='<script>alert(/xss/)</script>'　