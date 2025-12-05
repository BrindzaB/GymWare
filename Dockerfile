FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd pdo_mysql mbstring exif pcntl bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy entire project first
COPY . .

# Install dependencies
RUN composer install --no-interaction --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www

# Expose port for artisan serve
EXPOSE 8000

CMD ["php", "artisan", "serve", "--host=0.0.0.0"]