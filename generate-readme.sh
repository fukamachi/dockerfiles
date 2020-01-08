#!/bin/bash

REPOS=fukamachi/dockerfiles

image="$@"

if [ "$image" == "" ]; then
    echo "No image name is given."
    exit -1
fi

if [ ! -d "$image" ]; then
    echo "Invalid image name: ${image}"
    exit -1
fi

cd $image

image=$(basename `pwd`)

versions=( */ )
versions=( "${versions[@]%/}" )
IFS=$'\n'; versions=( $(echo "${versions[*]}" | sort -Vr) ); unset IFS

GIT_REF=$(git rev-parse HEAD)

echo "# Supported tags and respective \`Dockerfile\` links"
echo
echo "- [\`${versions[0]}\`, \`latest\`](https://github.com/${REPOS}/blob/${GIT_REF}/${image}/${versions[0]}/Dockerfile)"
echo "- [\`${versions[0]}-alpine\`, \`latest-alpine\`](https://github.com/${REPOS}/blob/${GIT_REF}/${image}/${versions[0]}/alpine/Dockerfile)"
unset versions[0]

for version in "${versions[@]}"; do
    echo "- [\`${version}\`](https://github.com/${REPOS}/blob/${GIT_REF}/${image}/${version}/Dockerfile)"
    echo "- [\`${version}-alpine\`](https://github.com/${REPOS}/blob/${GIT_REF}/${image}/${version}/alpine/Dockerfile)"
done
