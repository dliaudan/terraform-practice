#!/bin/bash

#This script install a docker compose.
#Note: here used centos repo cause for latast version of RHEL (currently 9) doesn't exist

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl start docker
sudo docker run hello-world