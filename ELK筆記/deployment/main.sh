#!/bin/bash


echo "Starting deploy es cluster ..."
source roles/env
echo "Source Env"

FILES=./roles/*/role.sh
for f in $FILES
do
  echo "Processing $f file..."
  bash $f
done

