FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing
RUN echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

# Install php 7
COPY files/get7.sh /get7.sh
RUN chmod 777 /get7.sh
RUN export TERM=xterm; /get7.sh

COPY files/init.sh /init.sh
chmod +x /init.sh

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
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
