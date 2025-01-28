# Use the official PHP image with Apache
FROM php:8.1-apache

# Update package manager and install required libraries
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    bcmath \
    tokenizer \
    intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/local/bin/composer

# Copy the Laravel application to the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Set correct permissions for Laravel (storage & bootstrap/cache)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Install Laravel dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Expose port 80 for Apache
EXPOSE 80
