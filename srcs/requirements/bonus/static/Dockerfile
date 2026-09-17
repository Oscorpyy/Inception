FROM debian:bullseye

RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY site/ /var/www/html/

RUN chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
