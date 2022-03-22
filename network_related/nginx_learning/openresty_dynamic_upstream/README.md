# intro
According to some customerize fire wall rule need to be elastic in nginx

here comes to have some work

# quick start
> docker-compose up -d

# modify ngixn.client:connection ${redis ip}
> docker exec -it redis hostname -i

# set some domain for nginx ...
### enter redis interface and set some valid domain
> set demo demo.testfire.net

### test whether it works with cli `curl`
> curl -I --user-agent demo localhost
```log
HTTP/1.1 200 OK
Server: openresty/1.9.15.1
Date: Tue, 03 Mar 2020 02:27:44 GMT
Content-Type: text/html;charset=ISO-8859-1
Connection: keep-alive
Set-Cookie: JSESSIONID=CCCB42FD7154285F4B4D0026EA6FCD4D; Path=/; HttpOnly
```

# refer:
- https://openresty.org/en/dynamic-routing-based-on-redis.html