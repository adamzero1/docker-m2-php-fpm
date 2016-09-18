#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

############################
# Setup
############################
apt-get update
apt-get install -y git-core autoconf bison libxml2-dev libbz2-dev libmcrypt-dev libcurl4-openssl-dev libssl-dev libsslcommon2-dev pkg-config libltdl-dev libpng-dev libpspell-dev libreadline-dev make libicu-dev libxslt1-dev libjpeg-dev checkinstall auto-apt
mkdir -p /etc/php7/conf.d
mkdir -p /etc/php7/cli/conf.d
mkdir /usr/local/php7

############################
# Download
############################
rm -Rf /tmp/php-src
cd /tmp
git clone -b PHP-7.0.11 https://github.com/php/php-src.git --depth=1
cd php-src

############################
# Build
############################
./buildconf --force && \
auto-apt run ./configure \
	--prefix=/usr/local/php7 \
	--enable-fpm \
	--enable-bcmath \
	--with-bz2 \
	--enable-calendar \
	--enable-exif \
	--enable-dba \
	--enable-ftp \
	--with-gettext \
	--with-gd \
	--enable-mbstring \
	--with-mcrypt \
	--with-mhash \
	--with-xsl \
	--with-jpeg-dir \
	--enable-intl \
	--enable-mysqlnd \
	--with-mysql=mysqlnd \
	--with-mysqli=mysqlnd \
	--with-pdo-mysql=mysqlnd \
	--with-openssl \
	--enable-pcntl \
	--with-pspell \
	--enable-shmop \
	--enable-soap \
	--enable-sockets \
	--enable-sysvmsg \
	--enable-sysvsem \
	--enable-sysvshm \
	--enable-wddx \
	--with-zlib \
	--enable-zip \
	--with-readline \
	--with-curl \
	--with-config-file-path=/etc/php7/cli \
	--with-config-file-scan-dir=/etc/php7/cli/conf.d && \
make -j `nproc` && \
#make test && \

############################
# Install
############################
checkinstall --pkgname=php --pkgversion=7 -y
cp /tmp/php-src/php_7-1_amd64.deb ~/
cp /tmp/php-src/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm
cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf
cp /tmp/php-src/php.ini-production /etc/php7/cli/php.ini

############################
# Configure
############################
sed -i 's/;listen.owner = nobody/listen.owner = www-data/' /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's/;listen.group = nobody/listen.group = www-data/' /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's/^group = nobody/group = www-data/' /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's/^user = nobody/user = www-data/' /usr/local/php7/etc/php-fpm.d/www.conf
sed -i 's/^listen = 127\.0\.0\.1:9000/listen = \/var\/run\/php-fpm.sock/' /usr/local/php7/etc/php-fpm.d/www.conf

update-alternatives --install /usr/bin/php php /usr/local/php7/bin/php 0

############################
# Done
############################
echo "Finished, run 'service php-fpm restart' to enable new build."
