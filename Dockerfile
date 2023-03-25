FROM php:8.2.3-fpm-bullseye

RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd zip pcntl
    
WORKDIR /var/www
