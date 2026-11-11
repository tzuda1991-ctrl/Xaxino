FROM php:8.3-apache
RUN apt-get update && apt-get install -y --no-install-recommends libzip-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev libicu-dev libonig-dev libxml2-dev unzip git && docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install -j$(nproc) pdo_mysql mysqli gd zip intl mbstring bcmath exif && a2enmod rewrite headers && rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY Files/ /var/www/html/
RUN cd core && composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts && mkdir -p storage/framework/{cache,sessions,views} bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache && chmod -R ug+rwX storage bootstrap/cache
COPY deploy/apache.conf /etc/apache2/sites-available/000-default.conf
COPY deploy/start.sh /usr/local/bin/xaxino-start
RUN chmod +x /usr/local/bin/xaxino-start
ENV APACHE_DOCUMENT_ROOT=/var/www/html
CMD ["/usr/local/bin/xaxino-start"]
