#!/usr/bin/env bash

set -e

IMAGE=$1

container_name="dotfiles-test-$(date +%s)"

podman run --name $container_name --rm --detach $IMAGE tail -f /dev/null
# always cleanup container on exit
trap "podman kill $container_name" EXIT 

podman exec -i $container_name bash < ./test.sh
