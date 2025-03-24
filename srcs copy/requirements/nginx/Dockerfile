FROM debian:bookworm

RUN apt update && apt upgrade && apt-get install -y\
	nginx

#COPY /conf/default /etc/nginx/sites-available/

CMD ["nginx", "-g", "daemon off;"]