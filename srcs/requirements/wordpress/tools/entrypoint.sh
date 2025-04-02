#!/bin/bash
set -e



export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/wordpress_db)
export TIMO_PASS=$(cat /run/secrets/timo_pass)
export ADMIN_PASS=$(cat /run/secrets/admin_pass)

# Ensure the target directory exists
mkdir -p /var/www/html

# If WordPress is not already installed, download and extract it
if [ ! -f /var/www/html/index.php ]; then
    wget -q https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz
    tar -xzf /tmp/latest.tar.gz -C /tmp
    mv /tmp/wordpress/* /var/www/html/
    rm -rf /tmp/wordpress /tmp/latest.tar.gz
    chown -R www-data:www-data /var/www/html
fi

chown -R www-data:www-data /var/www/html/*
chmod -R 755 /var/www/html/wp-content

cp "/var/www/html/wp-config-sample.php" "wp-config.php"

sed -i \
    -e "s/define( *'DB_HOST', *'[^']*'/define('DB_HOST', '${WORDPRESS_DB_HOST}'/" \
    -e "s/define( *'DB_NAME', *'[^']*'/define('DB_NAME', '${WORDPRESS_DB_NAME}'/" \
    -e "s/define( *'DB_USER', *'[^']*'/define('DB_USER', '${WORDPRESS_DB_USER}'/" \
    -e "s/define( *'DB_PASSWORD', *'[^']*'/define('DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}'/" \
    /var/www/html/wp-config.php
    # Set proper permissions
chown www-data:www-data /var/www/html/wp-config.php
chmod 644 /var/www/html/wp-config.php

wp core install --url=127.0.0.1 --title=INCEPTION --admin_user=timo_develop --admin_password=$ADMIN_PASS --admin_email=admin@admin.de --allow-root
if ! wp user get "timo" --field=user_login --path=/var/www/html --allow-root 2>/dev/null; then
	wp user create timo timo@timo.de --user_pass=$TIMO_PASS --porcelain --allow-root 
fi
#wp theme activate twentytwentyfour --allow-root

# Start PHP-FPM
exec php-fpm8.2 -F