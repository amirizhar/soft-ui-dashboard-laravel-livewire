# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/local/bin/composer

# Copy the Laravel application to the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Run Composer to install Laravel dependencies
RUN composer install

# Expose port 80 for Apache
EXPOSE 80
