#!/bin/bash
set -e

export MYSQL_PASSWORD=$(cat /run/secrets/wordpress_db)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root)

# Initialize the database directory (critical for first-time setup)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily in the background
mysqld_safe --datadir=/var/lib/mysql &

# Wait for MariaDB to fully start (more robust check)
echo "Waiting for MariaDB to start..."
for i in {1..30}; do
    if mysqladmin ping -hlocalhost --silent; then
        break
    fi
    sleep 1
done

# Create WordPress database and user
echo "Creating database and user..."
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Stop the temporary MariaDB instance
mysqladmin -uroot shutdown

# Start MariaDB in the foreground (as the main process)
exec mysqld_safe --datadir=/var/lib/mysql