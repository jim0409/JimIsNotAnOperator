# intro 
quick setup prometheus under centos7.

# quick setup(base for linux server)
- download prometheus .tar.gz
> wget https://github.com/prometheus/prometheus/releases/download/v2.23.0-rc.0/prometheus-2.23.0-rc.0.linux-amd64.tar.gz

- tar file ...
> tar zxvf ${prometheus.tar.gz}

- create a prometheus.yml with name `myprometheus.yml`
```yaml
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
```

- processing prometheus
>  ./prometheus --config.yaml myprometheus.yml

- access via web browser
> http://127.0.0.1:9090



# refer:
- https://prometheus.io/download/