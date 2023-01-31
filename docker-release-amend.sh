#!/bin/bash

set -eux

#
# Usage:
#   ./docker-release-amend.sh <image-name:tag> [<image-name:tag>...]
#

# Assume this amd64-only image exists in Docker Hub, and the arm64-only image exists in local
image_and_tag=$1
image_name=$(echo $image_and_tag | cut -d : -f 1)
tag_name=$(echo $image_and_tag | cut -d : -f 2)

get_arch() {
  case $(uname -m) in
    amd64|x86_64)
      echo x86-64
      ;;
    aarch64)
      echo arm64
      ;;
    *)
      uname -m
      ;;
  esac
}

arch=$(get_arch)

docker tag "$image_and_tag" "$image_and_tag-$arch"
docker push "$image_and_tag-$arch"
local_digest=$(docker manifest inspect -v "$image_and_tag-$arch" | jq -r '.Descriptor.digest')

for image in "$@"; do
  docker buildx imagetools create --append -t "$image" "$image_name@$local_digest"
done

docker_hub_url="https://hub.docker.com/layers/$image_name/$tag_name-arm64/images/sha256-$(echo "$local_digest" | cut -d : -f 2)"
echo "Delete Tag of $image_and_tag-$arch at Docker Hub.\nOpen $docker_hub_url"
open "$docker_hub_url"
