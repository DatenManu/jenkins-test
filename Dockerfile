FROM jenkins/jenkins:lts

USER root

# 1) Docker CLI installieren:
RUN apt-get update && apt-get install -y \
    docker.io \
    ca-certificates curl gnupg lsb-release

# 2) Docker Compose v2 (als Plugin) oder v1 (als separate Binary) installieren
#    Beispiel: Docker Compose v2 als Plugin:
RUN apt-get install -y docker-compose-plugin

# (Alternativ Docker Compose v1 via curl):
# RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
#      -o /usr/local/bin/docker-compose \
#     && chmod +x /usr/local/bin/docker-compose

# Jenkins zurück auf jenkins-User
USER jenkins

