FROM debian:bookworm

RUN apt update && apt upgrade && apt-get install -y\
	mariadb-server

CMD ["mysqld"]