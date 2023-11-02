#!/bin/sh

app=$1
version=$2

./build.sh "$app" "$version" debian
./build.sh "$app" "$version" ubuntu

./docker-release-amend.sh "fukamachi/$app:$version-debian" "fukamachi/$app:$version" "fukamachi/$app:latest-debian" "fukamachi/$app:latest"
./docker-release-amend.sh "fukamachi/$app:$version-ubuntu" "fukamachi/$app:latest-ubuntu"
