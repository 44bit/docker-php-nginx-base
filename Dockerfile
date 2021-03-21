ARG PHP_VERSION=8.0
ARG ALPINE=3.13
ARG TIMEZONE=Europe/Berlin

FROM php:${PHP_VERSION}-fpm-alpine${ALPINE}

RUN apk add --no-cache \
    zip \
    libzip-dev \
    postgresql-dev \
    nginx \
    supervisor \
    curl \
    && rm /etc/nginx/conf.d/default.conf

RUN docker-php-ext-install \
    pdo_pgsql \
    intl \
    opcache \
    zip

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && pecl install apcu-5.1.20 \
    && pecl install redis-5.3.3 \
    && docker-php-ext-enable apcu redis \
    && apk del .phpize-deps

COPY nginx.conf         /etc/nginx/nginx.conf
COPY fpm-pool.conf      /etc/php/php-fpm.d/www.conf
COPY php.ini            /etc/php/conf.d/custom.ini
COPY supervisord.conf   /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /application
WORKDIR /application

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /application \
    && chown -R nobody.nobody /run \
    && chown -R nobody.nobody /var/lib/nginx \
    && chown -R nobody.nobody /var/log/nginx

USER nobody
