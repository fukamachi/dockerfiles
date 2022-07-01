#!/bin/bash

set -ex

cd `dirname $0`

new_versions=( `curl -s https://api.github.com/repos/roswell/roswell/releases\?per_page\=5 | jq -r '.[] | .tag_name' | sed -e 's/^v//' | grep -v "^$(cat versions | awk -F, '{ printf "\\\\|^%s$", $1 }' | cut -b 4-)" | sort -V` )

debian_image="bullseye-slim"
alpine_image="3.16"
ubuntu_image="22.04"
libcurl_version="libcurl4-gnutls-dev"

for version in "${new_versions[@]}"; do
  echo "$version,$debian_image,$alpine_image,$ubuntu_image,$libcurl_version" > >(tee -a versions)
done
