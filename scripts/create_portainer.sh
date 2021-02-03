#!/bin/bash

# setup certificates first

docker run -d -p 127.0.0.1:9000:9000 -p 127.0.0.1:8000:8000 \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v /root/docker/portainer/data:/data \
        -v /etc/letsencrypt/live/docker.cookwi.com:/certs/live/docker.cookwi.com:ro \
        -v /etc/letsencrypt/archive/docker.cookwi.com:/certs/archive/docker.cookwi.com:ro \
        --name portainer-ce \
        portainer/portainer-ce:latest --ssl --sslcert /certs/live/docker.cookwi.com/cert.pem --sslkey /certs/live/docker.cookwi.com/privkey.pem