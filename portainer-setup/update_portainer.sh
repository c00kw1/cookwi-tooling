#!/bin/bash

docker pull portainer/portainer:latest
docker stop portainer
docker rm portainer
./create_portainer.sh