#!/bin/bash

set -eux

if [[ $# > 4 ]]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

image=$1; shift
version=$1; shift
target=$1; shift

if [ ! -d "$image" ]; then
    echo "Invalid image name: ${image}"
    exit -1
fi

exec $image/build.sh $version $target "$@"
