#!/bin/bash

ab -p post.json -T application/json -c 1000 -n 10000 http://127.0.0.1:9200/hello/employee