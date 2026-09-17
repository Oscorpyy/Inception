FROM debian:bullseye

RUN sed -i \
        's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' \
        /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y \
        wget \
        php \
        php-mysql \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html
RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" \
        -O /var/www/html/index.php
RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
