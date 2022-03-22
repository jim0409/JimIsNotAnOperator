#!/bin/bash

./nats-streaming-server-v0.18.0-linux-amd64/nats-streaming-server -c cluster1.config &
./nats-streaming-server-v0.18.0-linux-amd64/nats-streaming-server -c cluster2.config &
./nats-streaming-server-v0.18.0-linux-amd64/nats-streaming-server -c cluster3.config
