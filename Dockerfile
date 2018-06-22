FROM ubuntu:16.04
MAINTAINER Supachai Jaturaprom  "jaturaprom.su@gmail.com"

ENV TZ Asia/Bangkok

# Update and Installation package 
 RUN apt-get update && echo $TZ > /etc/timezone && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-get install -yq mariadb-server \
					mariadb-client php7.0 apache2 php7.0-mysql\
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*
					
# Add apache2 deamon to runit
RUN mkdir -p /etc/service/apache2  /var/log/apache2 ; sync 
COPY config/apache2/apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run  \
    && cp /var/log/cron/config /var/log/apache2/ \
    && chown -R www-data /var/log/apache2

# Add mysqld deamon to runit
RUN mkdir -p /etc/service/mysqld /var/log/mysqld ; sync 
COPY config/mysql/mysqld.sh /etc/service/mysqld/run
RUN chmod +x /etc/service/mysqld/run  \
    && cp /var/log/cron/config /var/log/mysqld/ \
    && chown -R mysql /var/log/mysqld

EXPOSE 80

CMD ["/sbin/my_init"]
