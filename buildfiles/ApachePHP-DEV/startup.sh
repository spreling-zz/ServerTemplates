#! /bin/bash
source /etc/apache2/envvars

tail -F /var/sites/customers/*/logs/* -F /var/log/apache2/*

exec apache2 -D FOREGROUND
