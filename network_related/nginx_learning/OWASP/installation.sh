#!/bin/bash

# install some pre-request pkgs
yum install -y httpd-devel apr apr-util-devel apr-devel  \
			pcre pcre-devel  libxml2 libxml2-devel zlib zlib-devel \
			openssl openssl-devel libtool wget git


# download nginx & owasp package
cd /root
wget 'http://nginx.org/download/nginx-1.9.2.tar.gz'
wget -O modsecurity-2.9.1.tar.gz https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.1/modsecurity-2.9.1.tar.gz


# unpack modsecurity
echo "----- unpack & install modsecurity -----"
tar xzvf /root/modsecurity-2.9.1.tar.gz -C /root
cd /root/modsecurity-2.9.1; ./autogen.sh; ./configure --enable-standalone-module --disable-mlogc
make && make install


# unpack nginx and config modsecurity
echo "----- unpack & install nginx -----"
tar xzvf /root/nginx-1.9.2.tar.gz -C /root
cd /root/nginx-1.9.2; ./configure --add-module=/root/modsecurity-2.9.1/nginx/modsecurity
make && make install


# download owasp core rule sets and configured
echo "----- git clone core rule sets -----"
git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git --local /usr/local/nginx/conf/owasp-modsecurity-crs
cp /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf.example  /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf


# config owasp files
echo "----- config default phase action -----"
sed -ie 's/SecDefaultAction "phase:1,log,auditlog,pass"/#SecDefaultAction "phase:1,log,auditlog,pass"/g' /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf
sed -ie 's/SecDefaultAction "phase:2,log,auditlog,pass"/#SecDefaultAction "phase:2,log,auditlog,pass"/g' /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf
sed -ie 's/#.*SecDefaultAction "phase:1,log,auditlog,deny,status:403"/SecDefaultAction "phase:1,log,auditlog,deny,status:403"/g' /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf
sed -ie 's/# SecDefaultAction "phase:2,log,auditlog,deny,status:403"/SecDefaultAction "phase:2,log,auditlog,deny,status:403"/g' /usr/local/nginx/conf/owasp-modsecurity-crs/crs-setup.conf


# enable rules
echo "----- enable rules -----"
cp /root/modsecurity-2.9.1/modsecurity.conf-recommended /usr/local/nginx/conf/modsecurity.conf
cp /root/modsecurity-2.9.1/unicode.mapping  /usr/local/nginx/conf/
sed -ie 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /usr/local/nginx/conf/modsecurity.conf


# enable some rules
echo "----- create config link -----"
cp /usr/local/nginx/conf/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/local/nginx/conf/owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
cp /usr/local/nginx/conf/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example /usr/local/nginx/conf/owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
cp /usr/local/nginx/conf/owasp-modsecurity-crs/rules/*.data /usr/local/nginx/conf

# new extra owasp config
cat << EOF > /usr/local/nginx/conf/modsec_includes.conf
include modsecurity.conf
include owasp-modsecurity-crs/crs-setup.conf
include owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
include owasp-modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf
Include owasp-modsecurity-crs/rules/REQUEST-903.9002-WORDPRESS-EXCLUSION-RULES.conf
include owasp-modsecurity-crs/rules/REQUEST-905-COMMON-EXCEPTIONS.conf
include owasp-modsecurity-crs/rules/REQUEST-910-IP-REPUTATION.conf
include owasp-modsecurity-crs/rules/REQUEST-911-METHOD-ENFORCEMENT.conf
include owasp-modsecurity-crs/rules/REQUEST-912-DOS-PROTECTION.conf
include owasp-modsecurity-crs/rules/REQUEST-913-SCANNER-DETECTION.conf
include owasp-modsecurity-crs/rules/REQUEST-920-PROTOCOL-ENFORCEMENT.conf
include owasp-modsecurity-crs/rules/REQUEST-921-PROTOCOL-ATTACK.conf
include owasp-modsecurity-crs/rules/REQUEST-930-APPLICATION-ATTACK-LFI.conf
include owasp-modsecurity-crs/rules/REQUEST-931-APPLICATION-ATTACK-RFI.conf
include owasp-modsecurity-crs/rules/REQUEST-932-APPLICATION-ATTACK-RCE.conf
include owasp-modsecurity-crs/rules/REQUEST-933-APPLICATION-ATTACK-PHP.conf
include owasp-modsecurity-crs/rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf
include owasp-modsecurity-crs/rules/REQUEST-942-APPLICATION-ATTACK-SQLI.conf
include owasp-modsecurity-crs/rules/REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION.conf
include owasp-modsecurity-crs/rules/REQUEST-949-BLOCKING-EVALUATION.conf
include owasp-modsecurity-crs/rules/RESPONSE-950-DATA-LEAKAGES.conf
include owasp-modsecurity-crs/rules/RESPONSE-951-DATA-LEAKAGES-SQL.conf
include owasp-modsecurity-crs/rules/RESPONSE-952-DATA-LEAKAGES-JAVA.conf
include owasp-modsecurity-crs/rules/RESPONSE-953-DATA-LEAKAGES-PHP.conf
include owasp-modsecurity-crs/rules/RESPONSE-954-DATA-LEAKAGES-IIS.conf
include owasp-modsecurity-crs/rules/RESPONSE-959-BLOCKING-EVALUATION.conf
include owasp-modsecurity-crs/rules/RESPONSE-980-CORRELATION.conf
include owasp-modsecurity-crs/rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
EOF
