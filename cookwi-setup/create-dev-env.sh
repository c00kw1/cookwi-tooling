#!/bin/bash

echo "START creating your environment"
docker network create cookwi-dev || true
echo "DOCKER create stack"
docker-compose -f ./docker-compose.yml --env-file ./dev/docker-env up -d
echo "DOCKER done"
