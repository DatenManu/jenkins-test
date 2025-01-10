# Nimm ein kleines Image, hier z.B. Nginx (Alpine-Version)
FROM nginx:alpine

# Kopiere unsere index.html in den Standardpfad von Nginx
COPY index.html /usr/share/nginx/html/index.html

# Nginx lauscht auf Port 80
EXPOSE 80
