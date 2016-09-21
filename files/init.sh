!#/bin/bash

# Add default user
useradd -U -m -u ${DEFAULT_USER_UID} -G sudo,www-data -d /home/magento ${DEFAULT_USER}

# Update PHP FPM config
sed -i "s/^user = www-data/user = ${DEFAULT_USER}/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/^group = www-data/group = ${DEFAULT_USER}/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/pm.max_children = 5/pm.max_children = 40/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/;php_flag\[display_errors\] = off/php_flag\[display_errors\] = on/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/;php_admin_value\[memory_limit\] = 32M/php_admin_value\[memory_limit\] = 512M/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/listen = \/run\/php\/php7\.0\-fpm\.sock/listen = 9000/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/listen = \/var\/run\/php-fpm\.sock/listen = 9000/g" /usr/local/php7/etc/php-fpm.d/www.conf
sed -i "s/;daemonize = yes/daemonize = no/g" /usr/local/php7/etc/php-fpm.conf
sed -i "s/memory_limit = 128M/memory_limit = 2G/g" /etc/php7/cli/php.ini
#php5enmod mcrypt
