#!/bin/sh

# 1. create permanent volumes named "postgre-sso" and "sso-themes" in portainer

# 2. create "sso-network" network in portainer as well, Bridge mode

# 3. we need a postgre db
docker run -d --name postgre-sso --restart unless-stopped \
           -e POSTGRES_USER=keycloak \
           -e POSTGRES_PASSWORD=Keycl04k! \
           -e POSTGRES_DB=keycloak \
           -v postgre-sso:/var/lib/postgresql/data \
           -p 5432:5432 \
           --network="sso-network" \
           postgres:latest

# 4. start keycloak
docker run -d --name sso --restart unless-stopped \
           -e DB_VENDOR=postgres \
           -e DB_ADDR=postgre-sso \
           -e DB_PORT=5432 \
           -e DB_USER=keycloak \
           -e DB_PASSWORD=Keycl04k! \
           -e DB_DATABASE=keycloak \
           -e KEYCLOAK_USER=admin \
           -e KEYCLOAK_PASSWORD=<TO_FILL> \
           -e PROXY_ADDRESS_FORWARDING=<TO_FILL> \
           -v sso-themes:/opt/jboss/keycloak/themes \
           -p 127.0.0.1:8081:8080 \
           --network="sso-network" \
           jboss/keycloak:latest