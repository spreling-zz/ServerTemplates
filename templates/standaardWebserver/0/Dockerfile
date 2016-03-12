FROM ubuntu:latest
MAINTAINER Harm Jacob Drijfhout <spreling@gmail.com>

RUN apt-get update && apt-get install -y nano
RUN apt-get install apache2
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY startup.sh /usr/local/bin/startup.sh

EXPOSE 80

CMD bash -C '/usr/local/bin/startup.sh';'bash'
