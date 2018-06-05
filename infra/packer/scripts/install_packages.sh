#!/bin/bash

# Apply system updates
sudo apt-get -y update

sudo apt-get install -y \
nginx \
libxslt-dev \
libxml2-dev \
zlib1g-dev \
mysql-client \
libmysqlclient-dev \
libgdbm-dev \
libncurses5-dev \
automake \
libtool \
bison \
libffi-dev \
libssl-dev

#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password test'
#sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password test'
#sudo apt-get -y install mysql-server


sudo echo "mysql-server mysql-server/root_password password testaircall" | sudo debconf-set-selections
sudo echo "mysql-server mysql-server/root_password_again password testaircall" | sudo debconf-set-selections
sudo apt-get -y install mysql-server
