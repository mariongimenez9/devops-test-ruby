#!/bin/bash

set -x

exec 1>/var/log/user_data.log 2>&1

APP_DIR=/var/www/devops-test-ruby/code

mv $${APP_DIR}/config/database.yml.example $${APP_DIR}/config/database.yml

sed -i 's/# Setup DB password here/testaircall/g' $${APP_DIR}/config/database.yml

systemctl enable nginx
systemctl start nginx

echo $${APP_DIR}
cd $${APP_DIR}
if [ "${env}" = "production" ]
then
  rm $${APP_DIR}/config/environments/test.rb
  rm $${APP_DIR}/config/environments/development.rb
  rm $${APP_DIR}/config/puma/development.rb
else
  rm $${APP_DIR}/config/environments/test.rb
  rm $${APP_DIR}/config/environments/production.rb
  rm $${APP_DIR}/config/puma/production.rb
#fi

#chown -R ubuntu:ubuntu $${APP_DIR}/config

#App dependencies:
RACK_ENV=${env} RAILS_ENV=${env} rake assets:precompile

#Database creation:
RACK_ENV=${env} RAILS_ENV=${env} rake db:create

#Database initialization:
RACK_ENV=${env} RAILS_ENV=${env} rake db:migrate

#Web server initialization:
RACK_ENV=${env} RAILS_ENV=${env} bundle exec puma &
