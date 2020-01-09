#!/bin/bash

cd `dirname $0`

curl -s https://api.github.com/repos/roswell/roswell/releases\?per_page\=5 | jq -r '.[] | .tag_name' | sed -e 's/^v//' | cat versions - | sort -V | uniq > versions
