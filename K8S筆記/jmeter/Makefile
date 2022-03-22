.PHONY: setup clean run test

CLI := kubectl --insecure-skip-tls-verify --kubeconfig /Users/jimweng/.kube/paradise.config --namespace=dev-pds
JmeterScript := some_script.jmx
# Makefile 下的 awk 要用 $$ 因為 `$` 是跳脫符
JmeterMaste_POD := $(shell ${CLI} get pods | grep 'jmeter-master' | awk '{print $$1}' )



test:
	@echo ${JmeterMaste_POD}

setup:
	@echo "start dist jmeter cluster"
	@${CLI} apply -f influxdb/
	@${CLI} apply -f slave/
	@${CLI} apply -f master/
	@${CLI} apply -f grafana/
	@echo "wait for a while!" && sleep 5
	@${CLI} exec -it deploy/influxdb-jmeter -- influx -execute 'CREATE DATABASE jmeter'
	@echo
	@${CLI} exec -it deploy/jmeter-grafana -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' \
							-X POST -H 'Content-Type: application/json;charset=UTF-8' \
							--data-binary '{"name":"jmeterdb","type":"influxdb", \
							"url":"http://jmeter-influxdb:8086","access":"proxy","isDefault":true, \
							"database":"jmeter","user":"admin","password":"admin"}'
	@echo
	@${CLI} exec -it deploy/jmeter-master -- cp -r /load_test /jmeter/load_test
	@${CLI} exec -it deploy/jmeter-master -- chmod 755 /jmeter/load_test
	@echo "finish setup"


run:
	@${CLI} exec -it deploy/jmeter-master -- rm -rf /tmp/*
	@${CLI} cp ${JmeterScript} ${JmeterMaste_POD}:/tmp
	@${CLI} exec -it deploy/jmeter-master -- /bin/bash /load_test /tmp/${JmeterScript}


clean:
	@echo "clear environment ..."
	@${CLI} delete -f influxdb/
	@${CLI} delete -f slave/
	@${CLI} delete -f master/
	@${CLI} delete -f grafana/