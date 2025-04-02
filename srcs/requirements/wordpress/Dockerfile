FROM debian:bookworm

RUN apt update && apt-get install -y\
	php-fpm \
	php-mysqli \
	curl \
	php-cgi \
	php-pdo \
	php-gd php-cli \
	php-mbstring \
	wget \
	unzip \
	mariadb-client \
	iputils-ping \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d

#COPY ./conf/wp-config.php /tmp/

#RUN chown www-data:www-data /var/www/html/wp-config.php

RUN rm -f /var/www/html/wp-admin/install.php

WORKDIR /var/www/html

COPY ./tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN chown -R www-data:www-data /var/www/html

ENTRYPOINT ["/entrypoint.sh"]