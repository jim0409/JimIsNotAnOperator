#!/bin/bash

# create geo pipeline
curl -XPUT -u elastic:changeme http://127.0.0.1:9200/_ingest/pipeline/geoip -H 'Content-Type: application/json' -d '
{
  "description" : "Add geoip info",
  "processors" : [
    {
      "geoip" : {
        "field" : "remote_addr"
      }
    }
  ]
}'

# create geo pipeline template
curl -XPUT -u elastic:changeme "http://127.0.0.1:9200/geo-pipeline-template" -H 'Content-Type: application/json' -d '
{
  "mappings": {
    "properties": {
      "geoip.location": {
        "type": "geo_point"
      }
    }
  }
}'
