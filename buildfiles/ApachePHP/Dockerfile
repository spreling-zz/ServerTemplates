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
      imagemagick \
      apache2 \
      php5-mysql \
      php5-mcrypt \
      php5-curl \
      php-apc \
      php5-xsl \
      php5-gd \
      php-pear \
      php5-imagick \
      libapache2-mod-php5 \
      libapache2-modsecurity && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# enable mcrypt en disable autoindex, status
RUN /usr/sbin/php5enmod mcrypt && \
    /usr/sbin/php5enmod imagick && \
    a2enmod rewrite && \
    a2dismod autoindex && \
    a2dismod status

# Set the locale
RUN locale-gen en_US.UTF-8
RUN locale-gen nl_NL.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LC_MONETARY nl_NL.UTF-8
ENV ALLOW_OVERRIDE **False**

# set some basic security settings
RUN echo "Servername $(cat /etc/hostname)" >> /etc/apache2/apache2.conf && \
    sed -i "s/ServerSignature.*/ServerSignature Off/g" /etc/apache2/conf-enabled/security.conf && \
    sed -i "s/ServerTokens.*/ServerTokens PROD/g" /etc/apache2/conf-enabled/security.conf && \
    sed -ie '/<Directory \/usr\/share>/,/<\/Directory>/ s|.*|#&|g' /etc/apache2/apache2.conf && \
    sed -ie '/<Directory \/>/,/<\/Directory>/ { \
                s_AllowOverride .*_AllowOverride None_; \
                s_Options .*_Options -FollowSymLinks -Includes -ExecCGI_; \
                s_Require all .*_Require all denied_}' \
                /etc/apache2/apache2.conf && \
    sed -ie '/<Directory \/var\/www\/>/,/<\/Directory>/ { \
                s_<Directory /var/www/>_<Directory /var/sites/>_; \
                s_Options .*_Options -FollowSymLinks -Includes -ExecCGI_; \
                s_AllowOverride .*_AllowOverride None_; \
                s_Require all .*_Require all granted_} \
    ' /etc/apache2/apache2.conf


#configure modsecurity
RUN mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf && \
    sed -i "s/SecRuleEngine DetectionOnly/SecRuleEngine On/g" /etc/modsecurity/modsecurity.conf && \
    sed -i "s/SecRequestBodyLimit 13107200/SecRequestBodyLimit 26214400/g" /etc/modsecurity/modsecurity.conf && \
    sed -i 's:</IfModule>: \
    \tInclude "/usr/share/modsecurity-crs/*.conf"\n\t \
    Include "/usr/share/modsecurity-crs/activated_rules/*.conf"\n \
    </IfModule>:' \
    /etc/apache2/mods-enabled/security2.conf && \
    ln -s /usr/share/modsecurity-crs/base_rules/modsecurity_crs_41_sql_injection_attacks.conf /usr/share/modsecurity-crs/activated_rules/

RUN sed -i.bak "s/post_max_size = 8M/post_max_size = 32M/" /etc/php5/apache2/php.ini && \
sed -i.bak "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php5/apache2/php.ini

#create folder structure for websites
RUN mkdir -p /var/sites/customers/main/www && \
    mkdir -p /var/sites/customers/main/logs && \
    touch /var/sites/customers/main/logs/error.log &&\
    touch /var/sites/customers/main/logs/access.log &&\
    a2ensite 000-default

ADD configs/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD configs/index.php /var/sites/customers/main/www/index.php

VOLUME /var/sites/customers/main/www

#add startup script to container
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod 755 /usr/local/bin/startup.sh

EXPOSE 80

CMD ["/usr/local/bin/startup.sh"]
