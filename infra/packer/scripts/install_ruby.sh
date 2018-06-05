#!/bin/bash

set -ev

# Installing Ruby
#gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
#curl -sSL https://get.rvm.io | bash -s stable
#. ~/.rvm/scripts/rvm
#rvm install 2.3.0
#rvm use 2.3.0 --default
#ruby -v

cd
wget http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
tar -xzvf ruby-2.3.0.tar.gz
cd ruby-2.3.0/
./configure
make
sudo make install
ruby -v

# Installing Rails
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get update && apt-get install -y nodejs openssl gcc g++ make
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
gem install rails -v 4.2.1

# bundle install
gem install bundler
sudo chown -R ubuntu:ubuntu ${APP_DIR}
cd ${APP_DIR}
bundle install 

