#!/bin/bash

if [ -f "/init.sh" ]; then
  echo "running init.sh"
  /bin/bash /init.sh
  rm /init.sh
fi

service rsyslog start
echo "rsys started"

service postfix start
echo "postfix started"

echo "starting php-fpm..."
/usr/local/php7/sbin/php-fpm
