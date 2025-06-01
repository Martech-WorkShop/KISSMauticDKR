#!/bin/bash

###---------------------------------###
###    Starting all the services    ###
###---------------------------------###

service mariadb start
service php8.3-fpm start
service apache2 start


###----------------------------------###
### Load the Database configuration ###
###----------------------------------###

# We can't send the commands until the DB engine is running
while ! mariadb-admin ping -h localhost --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

# We use the variables previously defined on the Dockerfile:
CREATE_DB_CMD="CREATE DATABASE IF NOT EXISTS \`$MAUTIC_DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
CREATE_USER_CMD="CREATE USER IF NOT EXISTS \`$MAUTIC_DB_USER\`@'%' IDENTIFIED BY '$MAUTIC_DB_PASSWORD';"
GRANT_PRIVILEGES_CMD="GRANT ALL PRIVILEGES ON \`$MAUTIC_DB_NAME\`.* TO \`$MAUTIC_DB_USER\`@'%';"
FLUSH_PRIVILEGES_CMD="FLUSH PRIVILEGES;"

# Execute the SQL commands.
echo "Executing: $CREATE_DB_CMD"
mariadb -u root -e "$CREATE_DB_CMD"
if [ $? -ne 0 ]; then echo "ERROR: Failed to execute CREATE_DB_CMD"; else echo "CREATE_DB_CMD successful."; fi

echo "Executing: $CREATE_USER_CMD"
mariadb -u root -e "$CREATE_USER_CMD"
if [ $? -ne 0 ]; then echo "ERROR: Failed to execute CREATE_USER_CMD"; else echo "CREATE_USER_CMD successful."; fi

echo "Executing: $GRANT_PRIVILEGES_CMD"
mariadb -u root -e "$GRANT_PRIVILEGES_CMD"
if [ $? -ne 0 ]; then echo "ERROR: Failed to execute GRANT_PRIVILEGES_CMD"; else echo "GRANT_PRIVILEGES_CMD successful."; fi

echo "Executing: $FLUSH_PRIVILEGES_CMD"
mariadb -u root -e "$FLUSH_PRIVILEGES_CMD"
if [ $? -ne 0 ]; then echo "ERROR: Failed to execute FLUSH_PRIVILEGES_CMD"; else echo "FLUSH_PRIVILEGES_CMD successful."; fi

cd /
echo "Attempting to import database from /mauticdb-dump.sql..."
if [ -f "/mauticdb-dump.sql" ] && [ -r "/mauticdb-dump.sql" ]; then
    echo "SQL dump file /mauticdb-dump.sql found and is readable."
    mariadb -u root -p"$MAUTIC_DB_PASSWORD" "$MAUTIC_DB_NAME" < /mauticdb-dump.sql
    MARIADB_IMPORT_EXIT_CODE=$?
    if [ $MARIADB_IMPORT_EXIT_CODE -eq 0 ]; then
        echo "Database import completed successfully."
    else
        echo "ERROR: Database import failed with exit code $MARIADB_IMPORT_EXIT_CODE."
    fi
else
    echo "ERROR: SQL dump file /mauticdb-dump.sql not found or not readable."
fi

###----------------------------------###
###    Keep the container running    ###
###----------------------------------###

# Keep the container running forever and ever and ever...
tail -f /dev/null
