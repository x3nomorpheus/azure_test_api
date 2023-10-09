FROM composer:latest AS composer
FROM php:8.0-apache

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

USER www-data

COPY --chown=www-data code/ /var/www/html
WORKDIR /var/www/html
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader
RUN composer clear-cache

RUN sed -i s,/var/www/html,/var/www/html/html,g /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80
