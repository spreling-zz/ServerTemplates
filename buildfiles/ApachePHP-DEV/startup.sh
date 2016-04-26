#! /bin/bash
set -e
source /etc/apache2/envvars

echo "Servername $(cat /etc/hostname)" >> /etc/apache2/apache2.conf

#chown www-data:www-data /var/www -R

exec apache2 -D FOREGROUND

tail -F /var/log/apache2/error.log -F /var/log/apache2/access.log
