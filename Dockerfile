# MySQL server sur Ubuntu
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
RUN apt-get install -y -q wget nano zip openssh-server

# Installation de MySQL
RUN echo "mysql-server-5.7 mysql-server/root_password password ${password_mysql}" | debconf-set-selections
RUN echo "mysql-server-5.7 mysql-server/root_password_again password ${password_mysql}" | debconf-set-selections
RUN apt-get -y -q install mysql-server-5.7
RUN usermod -d /var/lib/mysql/ mysql

# Modification de la configuration mysql pour autoriser les connexions exterieures
RUN rm -f /etc/mysql/mysql.conf.d/mysqld.cnf
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN chmod -f 644 /etc/mysql/mysql.conf.d/mysqld.cnf

# Ajout utilisateur "${login_ssh}"
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/${login_ssh} --gecos "User" ${login_ssh}

# Modification du mot de passe pour "${login_ssh}"
RUN echo "${login_ssh}:${password_ssh}" | chpasswd

# Ports
EXPOSE 22 3306 80

# Ajout des services a lancer au demarrage
RUN echo "service ssh start" >> /root/.bashrc
RUN echo "service mysql start" >> /root/.bashrc
