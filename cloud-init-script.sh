#!/bin/bash
echo ********************
echo Executing cloud-init-script as user $USER
echo ********************

sudo apt-get update
sudo apt-get -y install curl linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get -y install apt-transport-https ca-certificates
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

sudo add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs)  main"
sudo apt-get update

echo ************************************
echo Installing and configuring Docker
sudo apt-get -y install docker-engine
sudo docker run hello-world
sudo groupadd docker
# default user depends on the OS
sudo usermod -aG docker ubuntu
sudo systemctl enable docker

echo **********************
echo rebooting ....
sudo reboot
