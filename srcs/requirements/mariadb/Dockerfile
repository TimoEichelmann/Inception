FROM debian:bookworm

RUN apt update && apt upgrade -y \
    && apt-get install -y mariadb-server gosu

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY entrypoint.sh /entrypoint.sh

RUN chown -R mysql:mysql /var/lib/mysql

EXPOSE 3306

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]