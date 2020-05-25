#!/bin/sh

# 0. create volume named "jenkins" into portainer to keep jenkins configuration there

# 1. build our image
docker build . -t cookwi/jenkins:latest

# 2. launch jenkins
docker run \
    --name jenkins-docker -d -p 127.0.0.1:8080:8080 -p 127.0.0.1:50000:50000 \
    --group-add $(stat -c '%g' /var/run/docker.sock) \
    -v jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock \
    cookwi/jenkins:latest
# group-add is here to give jenkins user the rights to use parent (server) docker socket