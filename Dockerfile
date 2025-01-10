FROM jenkins/jenkins:lts

USER root

# Docker installieren
RUN apt-get update && apt-get install -y \
    docker.io \
    docker-compose-plugin

# Jenkins-User wieder aktivieren
USER jenkins

