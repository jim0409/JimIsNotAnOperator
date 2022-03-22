#!/bin/bash

# [DEBUG] cat ./config/ins_es.sh
# [DEBUG] cat ./config/jvm.options

echo "deploy es-master1 to $ES_M3"
# [DEBUG] cat ./config/elasticsearch_M3.yml
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/ins_es.sh $ES_M3:/tmp
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 bash /tmp/ins_es.sh

# replace elasticsearch yml
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/elasticsearch_M3.yml $ES_M3:/tmp
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 "sudo rm -rf /etc/elasticsearch/elasticsearch.yml"
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 "sudo mv /tmp/elasticsearch_M3.yml /etc/elasticsearch/elasticsearch.yml"

# replace jvm.options
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/jvm.options $ES_M3:/tmp
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 "sudo rm -rf /etc/elasticsearch/jvm.options"
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 "sudo mv /tmp/jvm.options /etc/elasticsearch/jvm.options"


# start elasticsearch
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_M3 "sudo systemctl start elasticsearch"