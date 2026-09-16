# Penultimate stable Debian release as required by Inception subject
FROM debian:bullseye

# Configure Debian archive snapshot repository and install Redis server
RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends redis-server \
    && rm -rf /var/lib/apt/lists/*

# Copy custom Redis configuration
COPY conf/redis.conf /etc/redis/redis.conf

# Expose internal Redis port (accessible only within Docker network)
EXPOSE 6379

# Run Redis server in the foreground with the custom configuration
CMD ["redis-server", "/etc/redis/redis.conf", "--daemonize", "no"]
