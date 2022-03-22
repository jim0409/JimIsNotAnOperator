# intro

ModSecurity原本是Apache上的一款开源WAF模块，可以有效的增强Web安全性。目前已经支持Nginx和IIS，配合Nginx的灵活和高效可以打造成生产级的WAF，是保护和审核Web安全的利器。

# 什么是ModSecurity
ModSecurity是一个入侵侦测与防护引擎，它主要是用于Web应用程序，所以也被称为Web应用程序防火墙(WAF)。它可以作为Web服务器的模块或是单独的应用程序来运作。ModSecurity的功能是增强Web Application 的安全性和保护Web application以避免遭受来自已知与未知的攻击。

ModSecurity计划是从2002年开始，后来由Breach Security Inc.收购，但Breach Security Inc.允诺ModSecurity仍旧为Open Source，并开放源代码给大家使用。
最新版的ModSecurity开始支持核心规则集(Core Rule Set)，CRS可用于定义旨在保护Web应用免受0day及其它安全攻击的规则。

ModSecurity还包含了其他一些特性，如并行文本匹配、Geo IP解析和信用卡号检测等，同时还支持内容注入、自动化的规则更新和脚本等内容。此外，它还提供了一个面向Lua语言的新的API，为开发者提供一个脚本平台以实现用于保护Web应用的复杂逻辑。

# 什么是OWASP CRS
OWASP是一个安全社区，开发和维护着一套免费的应用程序保护规则，这就是所谓OWASP的ModSecurity的核心规则集(即CRS)。ModSecurity之所以强大就在于OWASP提供的规则，我们可以根据自己的需求选择不同的规则，也可以通过ModSecurity手工创建安全过滤器、定义攻击并实现主动的安全输入验证。



# 安裝 ModSecurity
# pre-request
$ yum install -y httpd-devel apr apr-util-devel apr-devel  pcre pcre-devel  libxml2 libxml2-devel zlib zlib-devel openssl openssl-devel libtool

# steps to install a owasp nginx
$ cd /root
$ wget 'http://nginx.org/download/nginx-1.9.2.tar.gz'
$ wget -O modsecurity-2.9.1.tar.gz https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.1/modsecurity-2.9.1.tar.gz


$ tar xzvf modsecurity-2.9.1.tar.gz
$ cd modsecurity-2.9.1/
$ ./autogen.sh
$ ./configure --enable-standalone-module --disable-mlogc
$ make


$ tar xzvf nginx-1.9.2.tar.gz
$ cd nginx-1.9.2
$ ./configure --add-module=/root/modsecurity-2.9.1/nginx/modsecurity/
$ make && make install


# download owasp rules and configured
$ git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git
$ cp -rf owasp-modsecurity-crs  /usr/local/nginx/conf/
$ cd /usr/local/nginx/conf/owasp-modsecurity-crs
$ cp crs-setup.conf.example  crs-setup.conf

# config owasp rules
sed -ie 's/SecDefaultAction "phase:1,log,auditlog,pass"/#SecDefaultAction "phase:1,log,auditlog,pass"/g' crs-setup.conf
sed -ie 's/SecDefaultAction "phase:2,log,auditlog,pass"/#SecDefaultAction "phase:2,log,auditlog,pass"/g' crs-setup.conf
sed -ie 's/#.*SecDefaultAction "phase:1,log,auditlog,deny,status:403"/SecDefaultAction "phase:1,log,auditlog,deny,status:403"/g' crs-setup.conf
sed -ie 's/# SecDefaultAction "phase:2,log,auditlog,deny,status:403"/SecDefaultAction "phase:2,log,auditlog,deny,status:403"/g' crs-setup.conf

# enable rules
cd /root/modsecurity-2.9.1/
cp modsecurity.conf-recommended /usr/local/nginx/conf/modsecurity.conf
cp unicode.mapping  /usr/local/nginx/conf/


# open SecRuleEngine
$ vim /usr/local/nginx/conf/modsecurity.conf
SecRuleEngine On


# chose some rules for testing
### workdir ... change
cd /usr/local/nginx/conf/owasp-modsecurity-crs

### generate rules
cp rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
cp rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example rules/RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf
cp rules/*.data /usr/local/nginx/conf


# new extra file for owasp
vim /usr/local/nginx/conf/modsec_includes.conf
```
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
```

# make nginx site support owasp
```log
server {
  listen       80;
  server_name  example.com;

  location / {
	# the main config for owasp
    ModSecurityEnabled on;
	# the main config for owasp
    ModSecurityConfig modsec_includes.conf;

	proxy_pass http://demo.testfire.net;
  }
}
```


# testing
curl -H "Host: example.com" http://127.0.0.1/?id=1%20AND%201=1

# refer:
- https://www.modsecurity.org/

- https://www.hi-linux.com/posts/45920.html


# official download link
### ModSecurity
- https://github.com/SpiderLabs/ModSecurity/releases

### Nginx
- http://nginx.org/download/