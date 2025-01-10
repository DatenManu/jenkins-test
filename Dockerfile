FROM jenkins/jenkins:lts

USER root

# Docker CLI und Compose installieren
RUN apt-get update && apt-get install -y \
    docker.io \
    docker-compose-plugin \
    && curl -L "https://github.com/docker/compose/releases/download/v2.32.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

USER jenkins

