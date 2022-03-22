# intro
use ngx-filebeat-elasticsearch-kibana to draw a map parse geoIP.

# refer:
- https://www.elastic.co/guide/en/beats/filebeat/current/index.html


# testing-method
- use nc generate some wired packets~
>  printf "GET /index.html HTTP/1.1\r\nUser-Agent: nc/0.0.1\r\nHost: 1.1.1.1\r\nAccept: */*\r\n\r\nX-Forward-For/1.1.1.1\r\n" | nc 127.0.0.1 80

# 後記:
此處旨在紀錄如何部署nginx(access.log)->filebeat->es(pipeline)->kibana(template)，產線環境通常不會以container形式實現

- notes: 裡面nginx無法正確拿到remote_addr(因為會過docker network gateway)，需要在做額外調整
> https://github.com/nginx-proxy/nginx-proxy/issues/130

當 kibana 顯示 413 entity too large 時
- 修改 kibana.yml 參數
```
server.maxPayloadBytes: 104857600
savedObjects.maxImportPayloadBytes: 104857600
```
- 修改 elasticsearch.yml 參數
```
http.max_content_length: 500mb
```

> https://discuss.elastic.co/t/request-entity-too-large-when-importing-kibana-saved-objects/261497
<!-- https://stackoverflow.com/questions/58490210/the-remote-server-returned-an-error-413-request-entity-too-large-elasticsear -->