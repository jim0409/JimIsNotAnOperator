# intro
The world's most widely used web app scanner.
(Free and open source. Actively maintained by a dedicated international team of volunteers)

# quick start
### pre-install
1. docker


### ZAP headless
```bash
docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap.sh -daemon -host 0.0.0.0 -port 8080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.key=<api-key>
```
(Note: -config api.addrs.addr.name=.* opens the API up for connections from any other host, it is prudent to configure this more specifically for your network/setup.)


### ZAP headless with xvfb
```bash
docker run -u zap -p 8080:8080 -i owasp/zap2docker-stable zap-x.sh -daemon -host 0.0.0.0 -port 8080 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true
```
(Note: -config api.addrs.addr.name=.* opens the API up for connections from any other host, it is prudent to configure this more specifically for your network/setup.)


### ZAP CLI
ZAP CLI is a `ZAP wrapper written in Python`. It provides a simple way to do scanning from the command line:
```bash
docker run --rm -i owasp/zap2docker-stable zap-cli quick-scan --self-contained \
    --start-options '-config api.disablekey=true' http://demo.testfire.net \
    --output-format json
```


### Accessing the API from outside of the Docker container:
Docker appears to assign ‘random’ IP addresses, so an approach that appears to work is:
Run ZAP as a daemon listening on “0.0.0.0”:
```
docker run -p 8090:8090 -i owasp/zap2docker-stable zap.sh -daemon -port 8090 -host 0.0.0.0
```


### Scanning an app running on the host OS
IP addresses like localhost and 127.0.0.1 cannot be used to access an app running on the host OS from within a docker container.
To get around this you can use the following code to get an IP address that will work:
```bash
# docker run -t owasp/zap2docker-stable zap-baseline.py -t http://$(ip -f inet -o addr show docker0 | awk '{print $4}' | cut -d '/' -f 1):10080
docker run -t owasp/zap2docker-stable zap-baseline.py -t http://127.0.0.1:80
```


# integrated zap into CI/CD
### Run ZAP Quick Scan
0. Start the zap container
```bash
docker run --detach --name zap -u zap -v "$(pwd)/reports":/zap/reports/:rw \
  -i owasp/zap2docker-stable zap.sh -daemon -host 0.0.0.0 -port 8080 \
  -config api.addrs.addr.name=0.0.0.0 -config api.addrs.addr.regex=true \
  -config api.disablekey=true
```

1. use `zap-cli` to run quick zap scan
```bash
docker exec zap zap-cli --verbose quick-scan http://demo.testfire.net
```

2. By default the scan will only report on an alert level of `High` unless you use the flag `-l`
```bash
docker exec zap zap-cli --verbose quick-scan http://demo.testfire.net -l Medium
```

### Generate and View HTMl Report
Note to use the same volume you mounted in the docker container `/zap/reports`
```bash
docker exec zap zap-cli --verbose report -o /zap/reports/owasp-quick-scan-report.html --output-format html
```


# refer:
- https://medium.com/isurfbecause/how-does-this-work-f0800dc2e7e
- https://www.zaproxy.org/
- https://www.zaproxy.org/docs/api/#introduction

# refer-docker-with-zap:
- https://www.zaproxy.org/docs/docker/about/