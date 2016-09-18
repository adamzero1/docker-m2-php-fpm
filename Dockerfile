FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

# Install php 7
COPY files/get7.sh /get7.sh
RUN chmod 777 /get7.sh
RUN export TERM=xterm; /get7.sh

# Update PHP FPM config
#RUN sed -i "s/^user = www-data/user = magento/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/^group = www-data/group = magento/g" /usr/local/php7/etc/php-fpm.d/www.conf

#RUN sed -i "s/pm.max_children = 5/pm.max_children = 40/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/;php_flag\[display_errors\] = off/php_flag\[display_errors\] = on/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/;php_admin_value\[memory_limit\] = 32M/php_admin_value\[memory_limit\] = 512M/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/listen = \/run\/php\/php7\.0\-fpm\.sock/listen = 9000/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/listen = \/var\/run\/php-fpm\.sock/listen = 9000/g" /usr/local/php7/etc/php-fpm.d/www.conf
#RUN sed -i "s/;daemonize = yes/daemonize = no/g" /usr/local/php7/etc/php-fpm.conf
#RUN sed -i "s/memory_limit = 128M/memory_limit = 2G/g" /etc/php7/cli/php.ini
#RUN php5enmod mcrypt

# Install postfix
RUN export TERM=xterm; apt-get install -y --force-yes \
	postfix \
	rsyslog \
	--fix-missing

RUN apt-get clean

# Disable local delivery
RUN sed -i 's/mydestination = .*/mydestination = localhost/' /etc/postfix/main.cf

# Define mountable directories.
VOLUME ["/var/www/html"]

# Define working directory.
WORKDIR /usr/local/php7/

EXPOSE 9000
COPY files/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
