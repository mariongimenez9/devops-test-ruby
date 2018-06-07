#!/bin/bash

set -x

exec 1>/var/log/user_data.log 2>&1

APP_DIR=/var/www/devops-test-ruby/code

mv $${APP_DIR}/config/database.yml.example $${APP_DIR}/config/database.yml
#rm $${APP_DIR}/config/database.yml.example
sed -i 's/# Setup DB password here/testaircall/g' $${APP_DIR}/config/database.yml

systemctl enable nginx
systemctl start nginx

#aws s3  cp --sse aws:kms --sse-kms-key-id alias/dbmysql s3://aircallapp/${env} $${APP_DIR}/config/ --recursive
chown -R ubuntu:ubuntu $${APP_DIR}/config

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
fi

#App dependencies:
RACK_ENV=${env} RAILS_ENV=${env} rake assets:precompile

#Database creation:
RACK_ENV=${env} RAILS_ENV=${env} rake db:create

#Database initialization:
RACK_ENV=${env} RAILS_ENV=${env} rake db:migrate

#Web server initialization:
RACK_ENV=${env} RAILS_ENV=${env} bundle exec puma &
