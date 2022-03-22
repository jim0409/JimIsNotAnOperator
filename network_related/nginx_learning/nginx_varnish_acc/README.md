# intro
http_accelerator是被用來設計在反向proxy，

Varnish，ESI(Edge Side includes)的運作有點像是SSI(Server Side Include)

透過Varnish可以將一些常用的資訊緩存下來，增加使用者體驗

# Architecture
```
Client(End_User) -> Varnish(http_accelerator) -> Nginx(Web)
```

# purge varnish cache
> curl -X XCGFULLBAN http://localhost:8080

# expect response
>  curl -I http://localhost:8080/luni.png
```
HTTP/1.1 200 OK
Server: nginx/1.13.7
Date: Tue, 04 Feb 2020 12:24:36 GMT
Content-Type: image/png
Content-Length: 14143
Last-Modified: Tue, 04 Feb 2020 11:15:28 GMT
ETag: "5e395250-373f"
X-Varnish: 6 32773
Age: 110
Via: 1.1 varnish (Varnish/6.3)
Accept-Ranges: bytes
Connection: keep-alive
```
期望看到
1. Age: 大於0，代表網站快取成功，
2. Via: 1.1 varnish(Varnish/6.3) 

# refer:
- https://www.astralweb.com.tw/how-to-use-varnish-to-increase-the-speed-of-your-site/
- https://hub.docker.com/_/varnish

clear cache from varnish
- https://stackoverflow.com/questions/38892021/how-to-clear-complete-cache-in-varnish

mount varnish container cache to os
- https://stackoverflow.com/questions/41902930/docker-compose-tmpfs-not-working

some work use docker-compose to run varnish - nginx/php - mysql
- https://github.com/webkul/magento2-varnish-docker-compose

varnish-book: 解釋一些`varnish`的設定
- https://book.varnish-software.com/4.0/chapters/HTTP.html

中文講解varnish設定檔
- https://bonze.tw/varnish-nginx%E6%9C%AC%E6%A9%9Fnginx-docker/