FROM php:8.2-fpm-alpine

# Install common extensions as needed (uncomment what you need)
# RUN docker-php-ext-install pdo pdo_mysql opcache

WORKDIR /var/www/html
COPY ./public /var/www/html/public

EXPOSE 9000
CMD ["php-fpm"]
