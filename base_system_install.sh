#!/bin/bash
# Author: Alvinho - P&D - DTPD
# Ubuntu 16.04 x86-64 - Xenial Xerus and NVIDIA GPU

# Update OS
sudo apt -y update
sudo apt -y upgrade

# Install docker pre-requisites
sudo apt install -y git vim feh apt-transport-https \
ca-certificates curl htop software-properties-common

# Install docker CE official GPG keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add docker CE repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt -y update
sudo apt install -y docker-ce

# Install nvidia-docker2 repo and nvidia-docker-plugin
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt -y update

# Install NVIDIA docker2
sudo apt install -y nvidia-docker2
sudo apt-get -y autoremove

sudo systemctl daemon-reload
sudo systemctl restart docker

# Create project directory
mkdir -p "$HOME"/toflow
cd "$HOME"/toflow
# Create DockerFile
wget https://raw.githubusercontent.com/AlverGant/Toflow/master/Dockerfile -O Dockerfile
# "compile" docker images
sudo docker build -t toflow .

# create input and output folders
mkdir -p "$HOME"/input
mkdir -p "$HOME"/output

cd "$HOME"/toflow
sudo docker run --runtime=nvidia --rm -v "$HOME"/input:/input:ro -v "$HOME"/output:/output -it toflow