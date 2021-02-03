#!/bin/bash

set -ex

cd `dirname $0`

build_args=$1

new_versions=( `curl -s https://api.github.com/repos/roswell/roswell/releases\?per_page\=5 | jq -r '.[] | .tag_name' | sed -e 's/^v//' | grep -v "^$(cat versions | awk -F, '{ print $1 }')$" | sort -V` )

debian_image="buster-slim"
alpine_image="3.13"
ubuntu_image="20.04"
libcurl_version="libcurl3"

targets=("debian" "alpine" "ubuntu")

for version in "${new_versions[@]}"; do
  echo "New Roswell version found: $version"
  echo "$version,$debian_image,$alpine_image,$ubuntu_image,$libcurl_version" >> versions
  for target in "${targets[@]}"; do
    ./build.sh $version $target $build_args
    ../test.sh roswell $version $target
  done
done
