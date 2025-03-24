FROM debian:bookworm

RUN apt update && apt upgrade && apt-get install -y\
	nginx

COPY /conf/default /etc/nginx/sites-available/
#COPY /conf/nginx.conf /etc/nginx/

CMD ["nginx", "-g", "daemon off;"]
