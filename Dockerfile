FROM nginx:alpine

# Kopiere die index.html in den nginx-Webserver
COPY ./index.html /usr/share/nginx/html/index.html

# Standard-Port von nginx
EXPOSE 80

# Starte nginx im Vordergrund
CMD ["nginx", "-g", "daemon off;"]
