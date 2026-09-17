FROM debian:bullseye

RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y --no-install-recommends vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty /var/www/html

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY tools/ftp_setup.sh /usr/local/bin/ftp_setup.sh
RUN chmod +x /usr/local/bin/ftp_setup.sh

EXPOSE 21 21000-21010

CMD ["/usr/local/bin/ftp_setup.sh"]
