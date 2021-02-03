#!/bin/sh

# 1. create permanent volumes named "postgre-sso" and "sso-themes" in portainer

# 2. create "sso-network" network in portainer as well, Bridge mode

# 3. we need a postgre db
docker run -d --name sso-homologation-postgre --restart unless-stopped \
           -e POSTGRES_USER=keycloak \
           -e POSTGRES_PASSWORD=Keycl04k! \
           -e POSTGRES_DB=keycloak \
           -v sso-homologation-postgre:/var/lib/postgresql/data \
           -p 127.0.0.1:5432:5432 \
           --network="sso-homologation" \
           postgres:latest

# 4. start keycloak
docker run -d --name sso-homologation --restart unless-stopped \
           -e DB_VENDOR=postgres \
           -e DB_ADDR=sso-homologation-postgre \
           -e DB_PORT=5432 \
           -e DB_USER=keycloak \
           -e DB_PASSWORD=Keycl04k! \
           -e DB_DATABASE=keycloak \
           -e KEYCLOAK_USER=admin \
           -e KEYCLOAK_PASSWORD=5=m5r=7qjqk45rg879/G \
           -e PROXY_ADDRESS_FORWARDING=true
           -v sso-homologation-themes:/opt/jboss/keycloak/themes \
           -p 8081:8080 \
           --network="sso-homologation" \
           jboss/keycloak:latest