#!/usr/bin/env bash

set -e

container_id=$(docker run --rm --detach fedora:latest sleep infinity)

docker exec -i $container_id bash < ./test.sh

docker stop $container_id
docker rm $container_id
