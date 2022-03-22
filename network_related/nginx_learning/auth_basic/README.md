# intro
Authenticating proxy with nginx

# quick start
1. setup environment
> docker-compose up

2. test with curl
> curl -u username:password http://127.0.0.1:80 -I

3. check status
> curl localhost:8090/nginx_status


# refer:
- https://docs.docker.com/registry/recipes/nginx/
- https://github.com/dtan4/nginx-basic-auth-proxy


