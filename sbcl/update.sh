#!/bin/bash

set -ex

cd `dirname $0`

if [ ! -d sbcl-git ]; then
  git clone https://github.com/sbcl/sbcl sbcl-git
fi

cd sbcl-git

new_versions=( `git tag --sort=taggerdate --no-merged=233b11d5623a08e7703a9818c3b86bb4e981a920 -l "sbcl-*" | grep -v sbcl-sbcl- | sed -e 's/sbcl-//' | grep -v "^$(cat ../versions | awk -F, '{ printf "\\\\|^%s$", $1 }' | cut -b 4-)" | sort -V` )

cd ../

latest_roswell=$(cat ../roswell/versions | sort -Vr | head -n 1 | awk -F, '{ print $1 }')

for version in "${new_versions[@]}"; do
  echo "$version,$latest_roswell" > >(tee -a versions)
done
