# intro
在使用測試工具時，常常需要臨時寫入 DB 做檢查

但是操作 MySQL JDBC 又有點殺雞焉動牛刀...

於是使用 influxdb 這種提供 API 做寫入的 DB ，同時利用 grafana 做視覺呈現

# insert data
```bash
curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"

curl -XPOST http://127.0.0.1:8086/write -d '{"code":}'
curl -i -XPOST http://192.168.123.27:8086/write?db=HWDB --data-binary "HARDWARE,CPU="1" value=91, CPU="2" value=92 1422568543702900257"

```



# refer:
- https://docs.influxdata.com/influxdb/v2.0/api/#tag/Write
- https://hub.docker.com/_/influxdb