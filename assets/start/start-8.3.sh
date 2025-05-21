#!/bin/bash

###---------------------------------###
###    Starting all the services    ###
###---------------------------------###

# Start MariaDB service
service mariadb start

# Start PHP-FPM service
service php8.3-fpm start

# Start Apache service
service apache2 start


###----------------------------------###
### Load the Database configuration ###
###----------------------------------###

# We have to create a new database and add a user,
# but we can't send the commands until the DB engine
# is effectively running and ready for commands,
# so let's make sure MariaDB is running...
while ! mariadb-admin ping -h localhost --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 1
done

# We use the variables previously defined on the Dockerfile:
# ENV MAUTIC_DB_NAME=mautic-db
# ENV MAUTIC_DB_USER=mautic-db-user
# ENV MAUTIC_DB_PASSWORD=mautic-strong-password
CREATE_DB_CMD="CREATE DATABASE IF NOT EXISTS \`$MAUTIC_DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
CREATE_USER_CMD="CREATE USER IF NOT EXISTS \`$MAUTIC_DB_USER\`@'%' IDENTIFIED BY '$MAUTIC_DB_PASSWORD';"
GRANT_PRIVILEGES_CMD="GRANT ALL PRIVILEGES ON \`$MAUTIC_DB_NAME\`.* TO \`$MAUTIC_DB_USER\`@'%';"
FLUSH_PRIVILEGES_CMD="FLUSH PRIVILEGES;"

# Execute the SQL commands.
mariadb -u root -e "$CREATE_DB_CMD"
mariadb -u root -e "$CREATE_USER_CMD"
mariadb -u root -e "$GRANT_PRIVILEGES_CMD"
mariadb -u root -e "$FLUSH_PRIVILEGES_CMD"

cd /
echo "Attempting to import database from /mauticdb-dump.sql..."
if [ -f "/mauticdb-dump.sql" ] && [ -r "/mauticdb-dump.sql" ]; then
    echo "SQL dump file /mauticdb-dump.sql found and is readable."
    mysql -u root -p"$MAUTIC_DB_PASSWORD" "$MAUTIC_DB_NAME" < /mauticdb-dump.sql
    MYSQL_EXIT_CODE=$?
    if [ $MYSQL_EXIT_CODE -eq 0 ]; then
        echo "Database import completed successfully."
    else
        echo "ERROR: Database import failed with exit code $MYSQL_EXIT_CODE."
    fi
else
    echo "ERROR: SQL dump file /mauticdb-dump.sql not found or not readable."
fi

###----------------------------------###
###    Keep the container running    ###
###----------------------------------###

# Keep the container running forever and ever and ever...
tail -f /dev/null
