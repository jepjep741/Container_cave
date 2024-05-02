# Offical php image with Apache
FROM php:8.3.6-apache

# Install MAtomo extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Ainstall depencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip


COPY security.conf /etc/apache2/conf-available
#Copy the web stuff

COPY matomo /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Coypy MAtomo configs
# COPY config.ini.php /var/www/html/config/config.ini.php

# check that mod_rewrite works.
RUN a2enmod rewrite

# use own ini file if needed.
# COPY custom-php.ini /usr/local/etc/php/conf.d/

# show  portti 80
EXPOSE 80
