#!/bin/bash

owner=fukamachi

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

versions=( `cat versions | sort -Vr` )

echo "# Docker images for $image"
echo
echo "## Usage"
echo
echo "\`\`\`"
echo "$ docker pull $owner/$image"
echo "$ docker run -it --rm $owner/$image"
echo "$ docker pull $owner/$image:${versions[1]}"
echo "$ docker run -it --rm $owner/$image:${versions[1]}"
echo "\`\`\`"
echo
echo "## Supported tags"
echo
echo "- \`${versions[0]}\`, \`${versions[0]}-debian\`, \`latest\`, \`latest-debian\`"
echo "- \`${versions[0]}-alpine\`, \`latest-alpine\`"
unset versions[0]

for version in "${versions[@]}"; do
    echo "- \`${version}\`, \`${version}-debian\`"
    echo "- \`${version}-alpine\`"
done

echo
echo "## Building by your own"
echo
echo "\`\`\`"
echo "$ docker build -t $image:${versions[1]} --build-arg VERSION=${versions[1]} sbcl/debian/"
echo "\`\`\`"
