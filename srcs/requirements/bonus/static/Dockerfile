# Penultimate stable Debian release as required by Inception subject
FROM debian:bullseye

# Configure Debian archive snapshot repository and install NGINX (no PHP installed)
RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

# Copy custom lightweight NGINX configuration for serving static files
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Copy website files (HTML, CSS, assets) into standard web directory
COPY site/ /var/www/html/

# Ensure correct file permissions for www-data
RUN chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# Expose internal HTTP port (accessible only within Docker network)
EXPOSE 80

# Run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
