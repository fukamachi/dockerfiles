#!/bin/bash

set -eu

#
# Usage:
#   ./docker-release-amend.sh <image-name:tag> [<image-name:tag>...]
#

# Assume this amd64-only image exists in Docker Hub, and the arm64-only image exists in local
image_and_tag=$1

arch=$(case $(uname -m) in amd64|x86_64) echo x86-64;; aarch64) echo arm64;; *) uname -m ;; esac)

remote_digest=$(docker manifest inspect -v "$image_and_tag" | jq -r '.Descriptor.digest')
docker push "$image_and_tag-$arch"
local_digest=$(docker manifest inspect -v "$image_and_tag-$arch" | jq -r '.Descriptor.digest')

for image in "$@"; do
  docker manifest create "$image" "$remote_digest" "$local_digest"
  docker manifest push --purge "$image"
done

docker_hub_url=$(open https://hub.docker.com/layers/fukamachi/<image>/<version>-<os>-arm64>/images/sha256-$(echo "$arm64_digest" | cut -d : -f 2))
echo "Delete Tag of $image_and_tag-$arch at Docker Hub.\nOpen $docker_hub_url"
open "$docker_hub_url"
