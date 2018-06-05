#!/bin/sh

set -e
set -x


# Copy base code
#mkdir -p $rootdir
#mv ${TMP_DIR}/worker.tar.gz ${appdir}
#cd ${appdir}
#tar zxvf worker.tar.gz --strip-components=1
#tar zxvf worker.tar.gz
#sudo chown -R ubuntu:ubuntu ${appdir}

sudo chown -R ubuntu:ubuntu ${ROOT_DIR}
cd ${ROOT_DIR}
git clone https://github.com/mariongimenez9/devops-test-ruby.git
sudo chown -R ubuntu:ubuntu ${APP_DIR}
