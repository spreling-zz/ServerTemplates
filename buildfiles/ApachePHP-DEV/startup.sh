#! /bin/bash
chown -R www-data:www-data /var/www

source /etc/apache2/envvars

echo "Servername $(cat /etc/hostname)" >> /etc/apache2/apache2.conf

exec apache2 -D FOREGROUND

tail -F /var/sites/customers/*/logs/* -F /var/log/apache2/*
