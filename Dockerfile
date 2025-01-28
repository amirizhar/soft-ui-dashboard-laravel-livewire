# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Enable apache rewrite module
RUN a2enmod rewrite

# Copy the Laravel application to the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Run Composer to install Laravel dependencies
RUN composer install

# Expose port 80 for Apache
EXPOSE 80
