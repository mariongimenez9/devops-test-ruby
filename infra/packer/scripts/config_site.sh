#!/bin/sh

set -e
set -x

# Configure nginx
# Remove nginx default website for port 80
cp ${APP_DIR}/config/nginx/server.conf /etc/nginx/sites-enabled/server.conf
sed -i "s#/path/to/app/devops-test#${APP_DIR}#g" /etc/nginx/sites-enabled/server.conf
rm /etc/nginx/sites-enabled/default
# Disable autostart of nginx to avoid cache lazy warmup linked to healthchech
systemctl disable nginx
