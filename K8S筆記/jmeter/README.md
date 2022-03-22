# intro

use JMeter as the main well-known load testing tool.

# quick start
1. setup env
> make setup

2. run test
> make run

3. clean up
> make clean

<!-- by default, use grafana-jmeter as the test target ... -->

# check
```log
╭─jimweng@JimWengs-MacBook-Pro ~/LinuxIssue/K8S筆記/jmeter ‹master*› 
╰─$ kubectl_dev-pds exec -it deploy/influxdb-jmeter -- influx
Connected to http://localhost:8086 version 1.8.6
InfluxDB shell version: 1.8.6
> show databases;
name: databases
name
----
jmeter
_internal
> use jmeter;
Using database jmeter
> show measurements;
name: measurements
name
----
events
jmeter
> select * from jmeter;
name: jmeter
time                application     avg  count countError endedT hit max maxAT meanAT min minAT pct90.0 pct95.0 pct99.0 rb    sb    startedT statut transaction
----                -----------     ---  ----- ---------- ------ --- --- ----- ------ --- ----- ------- ------- ------- --    --    -------- ------ -----------
1624353480002000000 demo-jmeter-k8s                       0              0     0          0                                         0               internal
1624353481593000000 demo-jmeter-k8s 2.75 80    0                 80  46               0         2       3       46      68000 30400          all    all
1624353481595000000 demo-jmeter-k8s 2.75 80                          46               0         2       3       46      68000 30400          all    homepage
1624353481596000000 demo-jmeter-k8s 2.75 80                          46               0         2       3       46                           ok     homepage
1624353481597000000 demo-jmeter-k8s                       4              1     0          0                                         4               internal
```

# refer:
- https://blog.kubernauts.io/load-testing-as-a-service-with-jmeter-on-kubernetes-fc5288bb0c8b
- https://github.com/justb4/docker-jmeter
- https://github.com/kubernauts/jmeter-kubernetes