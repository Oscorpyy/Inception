FROM debian:bullseye

RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends redis-server \
    && rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf", "--daemonize", "no"]
