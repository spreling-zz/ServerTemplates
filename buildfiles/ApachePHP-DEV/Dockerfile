FROM ubuntu:latest
MAINTAINER Harm Jacob Drijfhout <spreling@gmail.com>

# Configure timezone
RUN echo "Europe/Amsterdam" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
ENV TERM xterm

# update packagemanager, get all required package and remove packagemanger index after that
# As last there is a manual install php composer
RUN apt-get install -y software-properties-common && \
    add-apt-repository main && add-apt-repository universe && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install  \
      curl \
      apache2 \
      libapache2-mod-php5 \
      php5-mysql \
      php5-mcrypt \
      php5-gd \
      php5-curl \
      php-pear \
      php-apc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# enable mcrypt en disable autoindex, status
RUN /usr/sbin/php5enmod mcrypt && \
    a2enmod rewrite

# Set the locale
RUN locale-gen en_US.UTF-8
RUN locale-gen nl_NL.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_MONETARY nl_NL.UTF-8

# set some basic security settings
RUN sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php5/apache2/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php5/apache2/php.ini && \
    sed -i "s/display_errors = Off/display_errors = On/" /etc/php5/apache2/php.ini && \
    sed -i "s/display_startup_errors = Off/display_startup_errors = On/" /etc/php5/apache2/php.ini


# Fix permissions
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www


#create folder structure for websites
COPY configs/index.php /var/www/index.php
COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default

VOLUME /var/www/

#add startup script to container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh

EXPOSE 80

CMD ["/usr/local/bin/startup.sh"]
