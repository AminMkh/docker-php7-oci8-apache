FROM php:7-apache

MAINTAINER Amin Mkh <mukh_amin@yahoo.com> 

# installing required stuff
RUN apt-get update \
    && apt-get install -y unzip libaio-dev libmcrypt-dev git \
    && apt-get clean -y

# PHP extensions
RUN \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install mcrypt

# xdebug, if you want to debug
RUN pecl install xdebug

# PHP composer
RUN curl -sS https://getcomposer.org/installer | php --  --install-dir=/usr/bin --filename=composer

# apache configurations, mod rewrite
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Oracle instantclient

	# copy oracle files
ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
ADD oracle/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/
# unzip them
RUN unzip /tmp/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip -d /usr/local/
# install pecl
RUN curl -O http://pear.php.net/go-pear.phar \
    ; /usr/local/bin/php -d detect_unicode=0 go-pear.phar
# install oci8
RUN ln -s /usr/local/instantclient_12_1 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && echo 'instantclient,/usr/local/instantclient' | pecl install oci8
