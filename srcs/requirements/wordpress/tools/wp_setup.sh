#!/bin/bash

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Reading Docker secrets..."
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

    echo "Configuring Redis cache in wp-config.php..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root

    echo "Installing and activating Redis Object Cache plugin..."
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
    
    echo "Installation completed successfully!"
fi

if ! wp plugin is-installed redis-cache --allow-root 2>/dev/null; then
    echo "Configuring Redis cache on pre-existing installation..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE true --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root
fi

echo "Setting correct permissions..."
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM in the foreground..."
exec /usr/sbin/php-fpm7.4 -F
