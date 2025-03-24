FROM debian:bookworm

RUN apt update && apt upgrade && apt-get install -y\
	mariadb-server

COPY /conf/50-server.cnf /etc/mysql/mariadb.conf.d

RUN mkdir /run/mysqld

CMD ["mysqld"]