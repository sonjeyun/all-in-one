FROM nginx:latest
LABEL maintainer="jeyun"
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
