# intro
### What is DNS over HTTPS and why it's important
DNS系統於1987年問世，但當時還沒有一定的安全及隱私考量。換句話說，DNS的查詢過程是完全暴露在中間的網路層的

鑑於此，有些例子像是中國的Great Firewall(GFW)使用`DNS cache poison`來感知一些中國境內的網段去確認訪問的域名是否合法
(*當然，方法可能不止於這一種)

GFW會利用spoof檢查每一條DNS查詢，遞歸查詢到外部DNS外部主機

當他查詢到一條座落在他黑名單內的domain name，他可以透過修改DNS回應來阻止訪問

假設，某一位使用者他在中國境內想要訪問`google.com`，GFW會回傳一錯誤的解析IP以至於使用者無法正常訪問

> 於此，倘若不使用UDP而改用HTTPS，則可以利用其加密協定來做查詢。如此一來就無人能知道當下查詢的封包內容


### Why Run Your Own DoH resolver?
然則，已經有一些知名的DNS resolvers像是`1.1.1.1`或是`9.9.9.9`已經支持DNS over HTTPS我們可以直接使用
(像是`Firefox version 61`開始，使用者已經可以直接在瀏覽器上啟用DNS over HTTPS ... 其resolver為`1.1.1.1`)

不過，如果我們想避免`1.1.1.1(cloudflare)`收集我們的數據，或防患可能三方遭受攻擊。自己架設會是更好的選擇


### DoH vs DoT
除了DNS over HTTPS還有另一項協議也支持DNS查詢的加密，DNS over TLS(DoT)

不過歸咎於服務端口，通常在中國境內的使用者會傾向使用DoH(443)而非DoT(853)

此外DoH的另一項優勢，是允許網頁透過瀏覽器直接進行DNS查詢
(*因為接收的協議頭是HTTPS)


### DoH Support in Major DNS Resolvers
- BIND : 在版本9.17之後都支持
- Knot : 在版本4.0.0之後都支持
- Unbount : 在1.12.0後支持
- PowerDNS recursor : 尚未支持...
(*或者可以透過DNSdist當作中介層，運行DoH)


### 前置準備
1. install DNSdist on Ubuntu Server
```sh
#!/bin/bash
# 以ubuntu 16.04為例
echo "deb [arch=amd64] http://repo.powerdns.com/ubuntu xenial-dnsdist-15 main" | sudo tee /etc/apt/sources.list.d/pdns.list

# add extra repo
sudo cat << EOF > /etc/apt/preferences.d/dnsdist
Package: dnsdist*
Pin: origin repo.powerdns.com
Pin-Priority: 600
EOF

# get repo-key
curl https://repo.powerdns.com/FD380FBB-pub.asc | sudo apt-key add -

# update and install it
sudo apt update; sudo apt install -y dnsdist

# since bind might listen on port 53, `dnsdist.service` need to change port
sudo cat << EOF > /etc/dnsdist/dnsdist.conf
setLocal("127.0.0.1:5353")
EOF

sudo systemctl restart dnsdist
```

2. install let's Encrypt Client(Certbot) on Ubuntu Server
```sh
#!/bin/bash
sudo apt install -y certbot
certbot --version
```

<!-- 
3. Obtain a Trusted TLS Certificate from let's Encrypt -- via standalone mode
```sh
#!/bin/bash
# hereby, use standalone plugin
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email "you@example.com" -d "doh.example.com"

# where
# certolny: Obtain a certificate but don't install it
# --standalone: Use the standalone plugin to obtain a certificate
# --preferred-challenges http: Perform http-01 challenge to validate our domain, which will use port 80.
# --agree-tos: Agree to Let's Encrypt terms of service
# --email: Email address is used for account registration and recovery.
# -d: Specify the domain name
``` -->

3. Obtain a Trusted TLS Certificate from let's Encrypt -- via webroot mode
```sh
#!/bin/bash
# Install a WebServer for Proxy
sudo apt install -y nginx
sudo cat << EOF > /etc/nginx/conf.d/doh.example.com.conf
server {
      listen 80;
      server_name doh.example.com;

      root /var/www/dnsdist/;

      location ~ /.well-known/acme-challenge {
         allow all;
      }
}
EOF

sudo mkdir -p /var/www/dnsdist
sudo chown -R www-data:www-data /var/www/dnsdist
# note: by default insallation ... 80 port might need modify to avoid conlict
# sudo systemctl reload nginx
```

4. Retrive ssl
```sh
#!/bin/bash
sudo certbot certonly --webroot --agree-tos --email "you@example.com" -d "doh.example.com" -w /var/www/dnsdist
```

5. Enable DoH in DNSdist
```sh
#!/bin/bash
# remove origin dnsdist.conf
sudo rm /etc/dnsdist/dnsdist.conf

# create the new dnsdist.conf
sudo cat << EOF > /etc/dnsdist/dnsdist.conf
-- allow query from all IP addresses
addACL('0.0.0.0/0')

-- add a DoH resolver listening on port 443 of all interfaces
addDOHLocal("0.0.0.0:443", "/etc/letsencrypt/live/doh.example.com/fullchain.pem", "/etc/letsencrypt/live/doh.example.com/privkey.pem", { "/" }, { doTCP=true, reusePort=true, tcpFastOpenSize=0 })

-- downstream resolver
newServer({address="127.0.0.1:53",qps=5, name="resolver1"})
EOF

sudo apt install acl
sudo setfacl -R -m u:_dnsdist:rx /etc/letsencrypt/

sudo dnsdist --check-config

sudo systemctl restart dnsdist
```

6. configure DoH in Firefox Web Browser
```
Preferences -> General -> Network Settings, Enable DNS over HTTPS ... Custom https://doh.linuxbabe.com
```

# Make DNSdist and web server use port 443 at the same time
### DNSdist Configuration
```sh
# remove origin dnsdist.conf
sudo rm /etc/dnsdist/dnsdist.conf

# create the new dnsdist.conf
sudo cat << EOF > /etc/dnsdist/dnsdist.conf
-- allow query from all IP addresses
addACL('0.0.0.0/0')

-- add a DoH resolver listening on port 443 of all interfaces
addDOHLocal("127.0.0.1:443", "/etc/letsencrypt/live/doh.example.com/fullchain.pem", "/etc/letsencrypt/live/doh.example.com/privkey.pem", { "/" }, { doTCP=true, reusePort=true, tcpFastOpenSize=0 })

-- downstream resolver
newServer({address="127.0.0.1:53",qps=5, name="resolver1"})
EOF

sudo systemctl restart dnsdist
```

### Nginx Configuration
```operation-sh
sudo nano /etc/nginx/conf.d/example.com.conf
listen 443 ssl;

.. change to ...

listen 127.0.0.2:443 ssl;

sudo systemctl restart nginx
```


# refer:
- https://www.linuxbabe.com/ubuntu/dns-over-https-doh-resolver-ubuntu-dnsdist

# install dnsdist
- https://dnsdist.org/install.html