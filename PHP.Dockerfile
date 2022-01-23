FROM php:8.1-fpm AS base

# File Author / Maintainer
LABEL maintainer="Frank Geyer<support@escait.de>"

# Use arguments from docker-compose.yml
ARG XDEBUG
ARG XDEBUG_CLIENT_HOST
ARG XDEBUG_PORT
ARG XDEBUG_IDEKEY

# Set workind directory
WORKDIR /app

# Install docker php extensions
RUN docker-php-ext-install pdo pdo_mysql

FROM base AS base_debug

# Install a text editor
RUN apt-get update \
    && apt-get --no-install-recommends install -y nano

# Install and configure xDebug
RUN if [ "${XDEBUG}" = 'true' ]; then \
    pecl install xdebug && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=develop,coverage,debug,profile" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=${XDEBUG_IDEKEY}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=${XDEBUG_CLIENT_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.discover_client_host=true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    ;\
fi;