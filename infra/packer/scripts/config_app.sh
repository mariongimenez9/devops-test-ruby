#!/bin/sh

set -e
set -x


# Copy base code

sudo chown -R ubuntu:ubuntu ${ROOT_DIR}
cd ${ROOT_DIR}
git clone https://github.com/mariongimenez9/devops-test-ruby.git
sudo chown -R ubuntu:ubuntu ${ROOT_DIR}
