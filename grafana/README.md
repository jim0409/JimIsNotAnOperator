# inro
quick setup grafana under centos7.

# quick setup
- create an new file to `/etc/yum.repos.d/grafana-oss.repo`
```bash
cat > /etc/yum.repos.d/grafana-oss.repo << EOF
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
```
- install vi yum
> yum install -y grafana

- reload system daemon
> systemctl daemon-reload

- start grafana-server
> systemctl start grafana-server

- check with browser
> http://127.0.0.1:3000

# refer:
### download doc
- https://grafana.com/docs/grafana/latest/installation/rpm/
### echo text to specific file
- https://stackoverflow.com/questions/11162406/open-and-write-data-to-text-file-using-bash