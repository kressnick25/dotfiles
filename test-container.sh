#!/usr/bin/env bash

set -e

container_id=$(podman run --rm --detach fedora:latest sleep infinity)

podman exec -i $container_id bash < ./test.sh

podman kill $container_id
