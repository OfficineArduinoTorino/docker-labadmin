#!/bin/bash

CONFIG_PATH=/data/options.json

DB_HOST=$(jq --raw-output ".db_host" $CONFIG_PATH)
DB_USERNAME=$(jq --raw-output ".db_username" $CONFIG_PATH)
DB_PASSWORD=$(jq --raw-output ".db_password" $CONFIG_PATH)
DB_NAME=$(jq --raw-output ".db_name" $CONFIG_PATH)
SECRET_KEY=$(jq --raw-output ".secret_key" $CONFIG_PATH)
ADMIN_NAME=$(jq --raw-output ".admin_name" $CONFIG_PATH)
ADMIN_EMAIL=$(jq --raw-output ".admin_email" $CONFIG_PATH)
ADMIN_PASS=$(jq --raw-output ".admin_pass" $CONFIG_PATH)

DB_HOST=$(echo ${DB_HOST} | sed "s/'/\\\'/g")
DB_USERNAME=$(echo ${DB_USERNAME} | sed "s/'/\\\'/g")
DB_PASSWORD=$(echo ${DB_PASSWORD} | sed "s/'/\\\'/g")
DB_NAME=$(echo ${DB_NAME} | sed "s/'/\\\'/g")
SECRET_KEY=$(echo ${SECRET_KEY} | sed "s/'/\\\'/g")

sed -i "s/.*# DB_HOST/'HOST': '${DB_HOST}', # DB_HOST/" djangolabadmin/settings.py
sed -i "s/.*# DB_USERNAME/'USER': '${DB_USERNAME}', # DB_USERNAME/" djangolabadmin/settings.py
sed -i "s/.*# DB_PASSWORD/'PASSWORD': '${DB_PASSWORD}', # DB_PASSWORD/" djangolabadmin/settings.py
sed -i "s/.*# DB_NAME/'NAME': '${DB_NAME}', # DB_NAME/" djangolabadmin/settings.py
sed -i "s/.*# SECRET_KEY/SECRET_KEY = '${SECRET_KEY}', # SECRET_KEY/" djangolabadmin/settings.py

python manage.py create_superuser_with_password --username "${ADMIN_NAME}" --password "${ADMIN_PASS}" --noinput --email "${ADMIN_EMAIL}"

python manage.py migrate
gunicorn -w 2 -b 0.0.0.0:8000 djangolabadmin.wsgi
