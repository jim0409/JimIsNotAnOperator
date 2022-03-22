# quick start
1. 帶起環境
> docker-compose up -d

2. 使用netcat做監聽
> nc -uv l 1515

3. 訪問網頁，確認access.log有著實記錄下來
> http://127.0.0.1:1515

4. 確認nc udp server的log是否正確
```log
<190>Feb 25 08:53:18 44cec08c15e7 nginx: localhost 172.26.0.1 http 2020-02-25T08:53:18+00:00 GET / 304 0 - 172.26.0.1 0.000 - "Mozilla/
5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36"<190>Feb 25 08:53:18 
44cec08c15e7 nginx: localhost 172.26.0.1 http 2020-02-25T08:53:18+00:00 GET /luni.png 304 0 http://localhost/ 172.26.0.1 0.000 - "Mozil
la/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36"
``` 

# refer:
- https://blog.techbridge.cc/2018/03/17/docker-build-nginx-tutorial/
- https://docs.nginx.com/nginx/admin-guide/monitoring/logging/
