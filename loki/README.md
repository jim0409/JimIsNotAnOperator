# intro
輕量化? 日誌系統

# pre-require
1. docker plugin install loki
> docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions 

2. enable loki plugin
> docker plugin enable loki

3. check loki plugin status
> docker plugin ls

<!--
感覺 loki 的衍生時空背景應該是類似傳統 VM 對比 docker
對比 ELK 架構，loki 可以搭配 grafana 更輕量快速的監控系統
-->

# refer:
- https://grafana.com/docs/loki/latest/clients/docker-driver/configuration/
- https://github.com/grafana/loki/blob/main/production/docker-compose.yaml
- https://malagege.github.io/blog/2021/04/18/Loki-%E5%88%9D%E9%AB%94%E9%A9%97%E6%95%99%E5%AD%B8/