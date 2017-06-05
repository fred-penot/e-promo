# Zend-server (Apache 2.4 & PHP7) sur Ubuntu
#
# VERSION               0.0.1
#

FROM     ubuntu:xenial
MAINTAINER Fwedoz "fwedoz@gmail.com"

# Definition des constantes
ENV password_mysql="docker"
ENV login_ssh="docker"
ENV password_ssh="docker"

# Mise a jour des depots
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)
 
# Installation des paquets de base
RUN apt-get install -y -q wget sudo nano zip openssh-server git

# Ajout du depot Zend Server
RUN echo "deb http://repos.zend.com/zend-server/9.0/deb_apache2.4 server non-free" >> /etc/apt/sources.list
RUN wget http://repos.zend.com/zend.key -O- |apt-key add -
RUN apt-get update

# Installation de Zend Server et mysql-client
RUN apt-get install -y -q zend-server-php-7.0 mysql-client-5.7

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Installation d e-promo
COPY install.sh /home/docker/install.sh
RUN chmod -f 755 /home/docker/install.sh
RUN chown -f ${login_ssh}:${login_ssh} /home/docker/install.sh
RUN sh /home/docker/install.sh

# Ports
EXPOSE 22 10081 10082 9945 80

# Ajout des services a lancer au demarrage
RUN echo "service ssh start" >> /root/.bashrc
RUN echo "service zend-server start" >> /root/.bashrc

# Lancement d e-promo au demarrage
RUN echo "/usr/local/zend/bin/php /home/docker/app/epromo/bin/console server:run 172.41.0.2:9945" >> /home/docker/.bashrc
RUN echo "chown -Rf ${login_ssh}:${login_ssh} /home/docker/app/epromo" >> /home/docker/.bashrc
RUN echo "chmod -Rf 777 /home/docker/app/epromo" >> /home/docker/.bashrc

USER docker

WORKDIR /home/docker
