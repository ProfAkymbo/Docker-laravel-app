# Use an official PHP image as the base image
FROM php:7.4-apache

# Set the working directory to /app
WORKDIR /app

# Copy the entire project to the container
COPY . /app

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
  && docker-php-ext-install \
    zip \
    pdo_mysql

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy the Apache configuration file to the container
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite for Apache
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
