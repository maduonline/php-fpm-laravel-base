FROM php:8.5.12-fpm-trixie

# Install mysql client for any dump requirements
RUN apt update && apt install -y default-mysql-client && rm -rf /var/lib/apt

# Use production ini file
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install most needed php extensions
# OPcache is compiled into PHP since 8.5, so it no longer needs installing
# Build redis from the phpredis GitHub tarball instead of PECL, so a pecl.php.net outage can't break the build
ARG PHPREDIS_VERSION=6.3.0
RUN docker-php-source extract \
    && mkdir /usr/src/php/ext/redis \
    && curl -fsSL "https://github.com/phpredis/phpredis/archive/refs/tags/${PHPREDIS_VERSION}.tar.gz" \
        | tar -xz -C /usr/src/php/ext/redis --strip-components=1 \
    && docker-php-ext-install redis \
    && docker-php-source delete
RUN docker-php-ext-install pdo_mysql

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd zip pcntl intl

# Copy opcache.ini file to setup opcache
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Set workdir
WORKDIR /var/www
