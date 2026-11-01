#!/bin/bash

# Run seeder
echo "Running database seeder on made-app..."
docker exec -it made-app ./seed

