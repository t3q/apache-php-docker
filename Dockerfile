FROM debian:jessie
MAINTAINER Jakub Zawierucha <jakub.zawierucha@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Niezbedne dla pythona
# Install program to configure locales
RUN apt-get update && apt-get install -y locales \
  && dpkg-reconfigure locales \
  && locale-gen C.UTF-8 \
  && /usr/sbin/update-locale LANG=C.UTF-8
# Install needed default locale for Makefly
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN echo "Europe/Warsaw" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# ** Keep the system updated as far as you can **
#run apt-get install python-virtualenv
#RUN apt-get install -y build-essential git
RUN apt-get clean \
  && apt-get update --fix-missing \
  && apt-get install -y \
  supervisor cron && \
  mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt-get clean \
  && apt-get update --fix-missing \
  && apt-get install -y nano apache2 php5 \
  libapache2-mod-php5 php5-mysql php5-curl php5-gd php5-intl \
  php5-mcrypt php5-xmlrpc

#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
ENV WEBSITE_HOST 0.0.0.0
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_SERVERADMIN admin@localhost
#ENV APACHE_SERVERNAME localhost
#ENV APACHE_SERVERALIAS docker.localhost
#ENV APACHE_DOCUMENTROOT /var/www

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh && /entrypoint.sh && rm -f /entrypoint.sh

RUN ln -s /etc/apache2/sites-available/vhost.conf /etc/apache2/sites-enabled/vhost.conf && \
    ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load && \
    a2enmod rewrite
#RUN ln -sf /dev/stdout /path/to/access.log
#RUN ln -sf /dev/stderr /path/to/error.log
EXPOSE 80

COPY crontab /var/spool/cron/crontabs/root

CMD ["/usr/bin/supervisord"]
