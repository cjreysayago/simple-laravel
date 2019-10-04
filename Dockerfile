FROM php:7.3-apache
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Dependencies
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip
# Nodejs
RUN apt-get install curl software-properties-common -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install nodejs -y

# Extensions
RUN docker-php-ext-install mbstring zip pdo pdo_mysql
# Install composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Change DocumentRoot
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

WORKDIR /var/www/html/
EXPOSE 80 443
