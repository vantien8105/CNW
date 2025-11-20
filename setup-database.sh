#!/bin/bash

# Script to setup MySQL database for Online Exam System

echo "Setting up Online Exam database..."

# MySQL connection details from .env
DB_PASSWORD="0355572520Aa@"
DB_NAME="online_exam_db"

# Check if MySQL is running
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL is not installed or not in PATH"
    exit 1
fi

# Create database and import schema
echo "Creating database and importing schema..."
mysql -u root -p${DB_PASSWORD} <<EOF
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
USE ${DB_NAME};

-- Import schema
source database/schema.sql;
EOF

if [ $? -eq 0 ]; then
    echo "✅ Database setup completed successfully!"
    echo ""
    echo "You can now access the application at:"
    echo "  http://localhost:8080/OnlineExam/login"
    echo ""
    echo "Demo accounts:"
    echo "  Teacher: teacher1 / password123"
    echo "  Student: student1 / password123"
else
    echo "❌ Database setup failed"
    exit 1
fi
