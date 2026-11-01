#!/bin/bash

# Load environment variables
if [ -f env/backend/.env ]; then
    export $(grep -v '^#' env/backend/.env | xargs)
else
    echo "Error: env/backend/.env not found"
    exit 1
fi

# Run migration
echo "Running migrations on made-app..."
docker compose exec -T app ./migrate -path ./migrations -database "postgres://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}?sslmode=disable" up

