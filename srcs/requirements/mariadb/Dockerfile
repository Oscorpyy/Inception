FROM debian:bullseye

RUN sed -i 's|^# deb http://snapshot|deb [check-valid-until=no] http://snapshot|g; s|^deb http://deb|# deb http://deb|g' /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh

EXPOSE 3306

CMD ["/usr/local/bin/mariadb_setup.sh"]
