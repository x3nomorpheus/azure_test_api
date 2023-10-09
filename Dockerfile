FROM composer:latest AS composer
FROM php:8.0-apache
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN adduser phpcomposeruser
USER phpcomposeruser
COPY code/ /var/www/
WORKDIR /var/www/code
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader
RUN composer clear-cache

RUN sed -i s,/var/www/html,/var/www/code,g /etc/apache2/sites-enabled/000-default.conf
EXPOSE 80
