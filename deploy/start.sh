#!/bin/sh
set -eu
: "${APP_KEY:?Set APP_KEY in Railway variables}"
: "${DB_HOST:?Set DB_HOST in Railway variables}"
mkdir -p /var/www/html/core/storage/framework/cache /var/www/html/core/storage/framework/sessions /var/www/html/core/storage/framework/views
chown -R www-data:www-data /var/www/html/core/storage /var/www/html/core/bootstrap/cache
sed -i "s/Listen 80/Listen ${PORT:-8080}/" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT:-8080}>/" /etc/apache2/sites-available/000-default.conf
exec apache2-foreground
