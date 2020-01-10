#!/bin/sh

arch=armhf

echo "Installing dependencies"
apt-get update
apt-get install -y --no-install-recommends \
    git \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo "Adding an APT repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=$arch] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "Installing Docker Engine"
apt-get update
apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

echo "Docker is successfully installed."
docker --version
