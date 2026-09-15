#!/bin/bash

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Reading Docker secrets..."
    # Retrieve passwords from the secret files
    DB_ROOT_PASSWORD=$(cat $WP_ADMIN_PASSWORD_FILE)
    DB_PASSWORD=$(cat $WP_USER_PASSWORD_FILE)

    echo "Creating wp-config.php configuration..."
    wp config create --dbname=$MYSQL_DATABASE \
                     --dbuser=$MYSQL_USER \
                     --dbpass=$DB_PASSWORD \
                     --dbhost=mariadb:3306 \
                     --allow-root

    echo "Installing WordPress..."
    wp core install --url=$DOMAIN_NAME \
                    --title="Inception Opernod" \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$DB_ROOT_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --allow-root

    echo "Creating the second user..."
    wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$DB_PASSWORD --allow-root
    
    echo "Installation completed successfully!"
fi

echo "Starting PHP-FPM in the foreground..."
exec /usr/sbin/php-fpm7.4 -F
