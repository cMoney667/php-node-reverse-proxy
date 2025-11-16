FROM nginx:alpine

COPY ./nginx/default.conf /etc/nginx/config.d/default.conf

EXPOSE 80

# Start command: render the template, then start nginx in foreground
CMD ["/bin/sh", "-c", \
  "envsubst < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && \
   exec nginx -g 'daemon off;'"]

#FROM alpine:latest
#
## Install all required packages
#RUN apk add --no-cache \
#    nginx \
#    php82 \
#    php82-fpm \
#    php82-opcache \
#    nodejs \
#    npm \
#    s6-overlay \
#    curl \
#    netcat-openbsd
#
## Create necessary directories
#RUN mkdir -p /var/www/html/public \
#    /etc/s6/services/nginx \
#    /etc/s6/services/php-fpm \
#    /etc/s6/services/node \
#    /app
#
## Copy Node.js application
#COPY node/package*.json /app/
#WORKDIR /app
#RUN npm ci --only=production
#COPY node/server.js /app/
#
## Copy PHP application
#COPY php/public /var/www/html/public
#
## Remove default nginx configs and copy our configuration
#RUN rm -f /etc/nginx/http.d/default.conf /etc/nginx/conf.d/default.conf 2>/dev/null || true && \
#    mkdir -p /etc/nginx/conf.d && \
#    rm -f /etc/nginx/conf.d/*.conf 2>/dev/null || true
#COPY nginx/default.conf /etc/nginx/http.d/default.conf
## Also copy to conf.d as backup (Alpine nginx may check both)
#COPY nginx/default.conf /etc/nginx/conf.d/default.conf
#
## Configure PHP-FPM to listen on port 9000
#RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' /etc/php82/php-fpm.d/www.conf || \
#    echo "listen = 0.0.0.0:9000" >> /etc/php82/php-fpm.d/www.conf
#
## Create s6 service run scripts
## Node.js service - start first
#RUN echo '#!/bin/sh' > /etc/s6/services/node/run && \
#    echo 'cd /app || exit 1' >> /etc/s6/services/node/run && \
#    echo 'echo "Starting Node.js server on 0.0.0.0:3000..."' >> /etc/s6/services/node/run && \
#    echo 'exec node server.js' >> /etc/s6/services/node/run && \
#    chmod +x /etc/s6/services/node/run
#
## PHP-FPM service
#RUN echo '#!/bin/sh' > /etc/s6/services/php-fpm/run && \
#    echo 'echo "Starting PHP-FPM..."' >> /etc/s6/services/php-fpm/run && \
#    echo 'exec php-fpm82 -F' >> /etc/s6/services/php-fpm/run && \
#    chmod +x /etc/s6/services/php-fpm/run
#
## Nginx service - wait for dependencies and then start
#RUN echo '#!/bin/sh' > /etc/s6/services/nginx/run && \
#    echo 'echo "Waiting for Node.js on port 3000..."' >> /etc/s6/services/nginx/run && \
#    echo 'i=0' >> /etc/s6/services/nginx/run && \
#    echo 'while [ $i -lt 60 ]; do' >> /etc/s6/services/nginx/run && \
#    echo '  if nc -z 127.0.0.1 3000 2>/dev/null; then' >> /etc/s6/services/nginx/run && \
#    echo '    echo "Node.js is ready on port 3000"' >> /etc/s6/services/nginx/run && \
#    echo '    break' >> /etc/s6/services/nginx/run && \
#    echo '  fi' >> /etc/s6/services/nginx/run && \
#    echo '  sleep 0.5' >> /etc/s6/services/nginx/run && \
#    echo '  i=$((i+1))' >> /etc/s6/services/nginx/run && \
#    echo 'done' >> /etc/s6/services/nginx/run && \
#    echo 'if [ $i -eq 60 ]; then' >> /etc/s6/services/nginx/run && \
#    echo '  echo "WARNING: Node.js did not become ready in time"' >> /etc/s6/services/nginx/run && \
#    echo 'fi' >> /etc/s6/services/nginx/run && \
#    echo 'echo "Waiting for PHP-FPM on port 9000..."' >> /etc/s6/services/nginx/run && \
#    echo 'i=0' >> /etc/s6/services/nginx/run && \
#    echo 'while [ $i -lt 60 ]; do' >> /etc/s6/services/nginx/run && \
#    echo '  if nc -z 127.0.0.1 9000 2>/dev/null; then' >> /etc/s6/services/nginx/run && \
#    echo '    echo "PHP-FPM is ready on port 9000"' >> /etc/s6/services/nginx/run && \
#    echo '    break' >> /etc/s6/services/nginx/run && \
#    echo '  fi' >> /etc/s6/services/nginx/run && \
#    echo '  sleep 0.5' >> /etc/s6/services/nginx/run && \
#    echo '  i=$((i+1))' >> /etc/s6/services/nginx/run && \
#    echo 'done' >> /etc/s6/services/nginx/run && \
#    echo 'if [ $i -eq 60 ]; then' >> /etc/s6/services/nginx/run && \
#    echo '  echo "WARNING: PHP-FPM did not become ready in time"' >> /etc/s6/services/nginx/run && \
#    echo 'fi' >> /etc/s6/services/nginx/run && \
#    echo 'echo "Starting Nginx..."' >> /etc/s6/services/nginx/run && \
#    echo 'nginx -t' >> /etc/s6/services/nginx/run && \
#    echo 'exec nginx -g "daemon off;"' >> /etc/s6/services/nginx/run && \
#    chmod +x /etc/s6/services/nginx/run
#
## Create finish scripts (optional - for cleanup on service exit)
#RUN touch /etc/s6/services/nginx/finish /etc/s6/services/php-fpm/finish /etc/s6/services/node/finish && \
#    chmod +x /etc/s6/services/nginx/finish /etc/s6/services/php-fpm/finish /etc/s6/services/node/finish
#
## Expose port 80
#EXPOSE 80
#
## Use s6 as init system
#ENTRYPOINT ["/init"]
#
