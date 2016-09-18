#!/bin/sh
service rsyslog start
echo "rsys started"

service postfix start
echo "postfix started"

echo "starting php-fpm..."
/usr/local/php7/sbin/php-fpm
