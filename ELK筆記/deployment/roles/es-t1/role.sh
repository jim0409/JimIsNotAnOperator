#!/bin/bash

# [DEBUG] cat ./config/ins_es.sh
# [DEBUG] cat ./config/jvm.options

echo "deploy es-master1 to $ES_T1"
# [DEBUG] cat ./config/elasticsearch_T1.yml
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/ins_es.sh $ES_T1:/tmp
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 bash /tmp/ins_es.sh

# replace elasticsearch yml
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/elasticsearch_T1.yml $ES_T1:/tmp
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 "sudo rm -rf /etc/elasticsearch/elasticsearch.yml"
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 "sudo mv /tmp/elasticsearch_T1.yml /etc/elasticsearch/elasticsearch.yml"

# replace jvm.options
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ./config/jvm.options $ES_T1:/tmp
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 "sudo rm -rf /etc/elasticsearch/jvm.options"
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 "sudo mv /tmp/jvm.options /etc/elasticsearch/jvm.options"

# start elasticsearch
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $ES_T1 "sudo systemctl start elasticsearch"