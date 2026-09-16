# Penultimate stable Debian release as required by Inception subject
FROM debian:bullseye

# Configure Debian archive snapshot repository and install vsftpd
RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Create directory required by vsftpd for privilege separation
RUN mkdir -p /var/run/vsftpd/empty /var/www/html

# Copy vsftpd configuration file
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Copy initialization script
COPY tools/ftp_setup.sh /usr/local/bin/ftp_setup.sh
RUN chmod +x /usr/local/bin/ftp_setup.sh

# Expose standard FTP port and passive port range
EXPOSE 21 21000-21010

# Run entrypoint script in foreground
CMD ["/usr/local/bin/ftp_setup.sh"]
