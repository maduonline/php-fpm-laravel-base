FROM php:8.3.13-fpm-bullseye

# Install mysql client for any dump requirements
RUN apt update && apt install -y default-mysql-client && rm -rf /var/lib/apt

# Use production ini file
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install most needed php extensions
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install pdo_mysql opcache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd zip pcntl intl

# Copy opcache.ini file to setup opcache
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Set workdir
WORKDIR /var/www
