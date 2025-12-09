#!/bin/bash

# Script to check current database schema

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-online_exam_db}"
DB_USER="${DB_USER:-root}"

echo "=== Checking Database Schema for: $DB_NAME ==="
echo ""

# Check if mysql client is available
if ! command -v mysql &> /dev/null; then
    echo "Error: mysql client not found. Please install MySQL client."
    exit 1
fi

echo "Enter MySQL password for user '$DB_USER':"

# Get table structures
echo ""
echo "=== USERS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE users;"

echo ""
echo "=== STUDENTS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE students;"

echo ""
echo "=== TEACHERS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE teachers;"

echo ""
echo "=== COURSES TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE courses;"

echo ""
echo "=== EXAMS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE exams;"

echo ""
echo "=== EXAM_SUBMISSIONS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE exam_submissions;"

echo ""
echo "=== EXAM_QUESTIONS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE exam_questions;"

echo ""
echo "=== COURSE_ENROLLMENTS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE course_enrollments;"

echo ""
echo "=== NOTIFICATIONS TABLE ==="
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p "$DB_NAME" -e "DESCRIBE notifications;"

echo ""
echo "=== Database schema check completed ==="
