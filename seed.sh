#!/bin/bash

# Run seeder
echo "Running database seeder on made-app..."
docker compose exec -T app ./seed

