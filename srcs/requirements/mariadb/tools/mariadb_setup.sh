#!/bin/bash

echo "Reading Docker secrets..."
DB_ROOT_PWD=$(cat $MYSQL_ROOT_PASSWORD_FILE)
DB_USER_PWD=$(cat $MYSQL_PASSWORD_FILE)

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB database..."
    
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld_safe &
    
    echo "Waiting for MariaDB to start..."
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    echo "Configuring database and users..."
    
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${DB_USER_PWD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';"
    mysql -u root -p"${DB_ROOT_PWD}" -e "FLUSH PRIVILEGES;"

    echo "Shutting down background MariaDB process..."
    mysqladmin -u root -p"${DB_ROOT_PWD}" shutdown
    
    echo "MariaDB setup completed successfully!"
else
    echo "Database already exists. Skipping initialization."
fi

echo "Starting MariaDB in the foreground..."
exec mysqld_safe
