#!/bin/bash

echo "Stopping containers"
sudo docker-compose down

echo "Downloading latest images from docker hub ... this can take a long time"
sudo docker-compose pull

echo "Building images if needed"
sudo docker-compose build

echo "Starting stack up again"
sudo docker-compose up -d

echo "Consider running prune-images to free up space"
