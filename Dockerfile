# Stage 1: Build the PHP extensions and dependencies
FROM php:8.2-apache AS build

RUN apt-get update && apt-get install -y \
    apt-utils \
    libzip-dev \
    zip \
    unzip \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    default-mysql-client \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    zip \
    bcmath \
    tokenizer \
    intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Stage 2: Copy the application and configure the web server
FROM php:8.2-apache

# Copy the installed extensions and libraries
COPY --from=build /usr/local/lib/php/extensions /usr/local/lib/php/extensions

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/local/bin/composer

# Set the working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
