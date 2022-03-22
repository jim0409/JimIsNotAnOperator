# intro

利用kong的反向代理，將minikube中的各項微服務導出

# components
1. kong
2. postgres(kong-db)
3. konga
4. konga-migration(one time job)

# create dummy site
1. click `SERVICE` > `+ADD NEW SERVICE`
2. type `Name: dummy-web` & `Url: http://demo.testfire.net`
3. click `dummy-web` 
4. choose `Routers` > `+ADD ROUTE`
5. type `Name: dummy-web-router` & `*Path: /dummy-web` & `*Method: GET` > `SUBMIT ROUTE`
(note with '*', need to click `enter` after type)
6. enter webpage within `http://${kong-address}:${kong-reverse-listen-port}/dummy-web/`


# refer:
- https://reurl.cc/4mOLyY

### some process shooting
- implement multi-ports into deployment and service
>  https://stackoverflow.com/questions/34502022/exposing-two-ports-in-google-container-engine
