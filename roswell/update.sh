#!/bin/bash

cd `dirname $0`

new_versions=( `curl -s https://api.github.com/repos/roswell/roswell/releases\?per_page\=5 | jq -r '.[] | .tag_name' | sed -e 's/^v//' | grep -v "^$(cat versions | awk -F, '{ print $1 }')$" | sort -V` )

debian_image="buster-slim"
alpine_image="3.10"
ubuntu_image="18.04"

for version in "${new_versions[@]}"; do
  echo "New Roswell version found: $version"
  echo "$version,$debian_image,$alpine_image,$ubuntu_image" >> versions
done
