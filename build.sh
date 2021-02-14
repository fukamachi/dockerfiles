#!/bin/bash

set -eux

# Usage: ./build.sh <app> <version> <os>
#
# Environment variables:
#   ARCH, BUILD_ARGS

if [[ $# > 3 ]]; then
  echo "Invalid number of arguments."
  exit 1
fi

cd `dirname $0`

app=$1; shift

if [ ! -d "$app" ]; then
    echo "Error: Invalid app name: ${app}"
    exit -1
fi

exec $app/build.sh "$@"
