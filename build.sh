#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

image=$1
version=$2
target=$3

if [ ! -d "$image" ]; then
    echo "Invalid image name: ${image}"
    exit -1
fi

exec $image/build.sh $version $target
