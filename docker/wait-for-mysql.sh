#!/bin/bash
set -e

echo "Waiting for MySQL to be ready..."

# Wait for MySQL to be available
attempt=0
while true; do
    if mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" --silent 2>/dev/null; then
        echo "MySQL is up - starting application"
        # Execute the remaining arguments as the command
        exec "$@"
    fi
    
    attempt=$((attempt + 1))
    if [ $attempt -gt 30 ]; then
        echo "MySQL connection failed after 60 seconds"
        exit 1
    fi
    
    echo "MySQL is unavailable - sleeping (attempt $attempt/30)"
    sleep 2
done
