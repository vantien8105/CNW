#!/bin/bash

# Script to add new students to the database

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-online_exam_db}"
DB_USER="${DB_USER:-root}"

echo "=== Adding New Students to Database: $DB_NAME ==="
echo ""

# Check if mysql client is available
if ! command -v mysql &> /dev/null; then
    echo "Error: mysql client not found. Please install MySQL client."
    exit 1
fi

echo "This script will add 9 new students and enroll them in courses."
echo "Database: $DB_NAME"
echo ""
echo "Enter MySQL password for user '$DB_USER':"

# Execute the SQL script
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" < database/add_students.sql

if [ $? -eq 0 ]; then
    echo ""
    echo "=== Students added successfully! ==="
else
    echo ""
    echo "=== Error adding students ==="
    exit 1
fi
