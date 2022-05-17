# 申請憑證
domain_name : `google.com`
> acme.sh --nginx --issue -d google.com-w /usr/share/nginx/html

# 更新憑證
> acme.sh -r -d google.com--force

# nginx 設定
```conf
...
server {
    listen       12100 ssl;
    server_name  google.com;
    ssl_certificate /root/.acme.sh/google.com/fullchain.cer;
    ssl_certificate_key /root/.acme.sh/google.com/google.com.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    root         /usr/share/nginx/html;
...
```


# refer:
<!-- crontab 參考網址 -->
- https://crontab.guru/#*_*_*_2_*
<!-- acme.sh 下載教學 -->
- https://www.kjnotes.com/devtools/103