#!/bin/sh

app=${1:-sbcl}
version=${2:-"$(cat "$app/versions" | tail -n 1 | awk -F, '{ print $1 }')"}

./build.sh "$app" "$version" debian
./build.sh "$app" "$version" ubuntu

./docker-release-amend.sh "fukamachi/$app:$version-debian" "fukamachi/$app:$version" "fukamachi/$app:latest-debian" "fukamachi/$app:latest"
./docker-release-amend.sh "fukamachi/$app:$version-ubuntu" "fukamachi/$app:latest-ubuntu"
