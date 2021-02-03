FROM jenkins/jenkins:lts

# we install docker in jenkins container in order to have the CLI
# we won't use engine, just cli with the parent (server) socket
USER root
RUN apt-get -qq update && apt-get -qq -y install curl
RUN curl -sSL https://get.docker.com/ | sh
RUN usermod -a -G docker jenkins

# we fallback to jenkins user since root is dangerous
USER jenkins