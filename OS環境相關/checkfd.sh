#!/bin/bash

PID=`ps -aef|grep -v "grep"|grep 'go run'|awk '{print $2}'`
watch -n1 lsof -p $PID
