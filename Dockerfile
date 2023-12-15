FROM nginx:latest

WORKDIR /app

COPY ./build/web/ /usr/share/nginx/html

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]