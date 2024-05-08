#!/bin/bash

yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp unzip openssl-devel

cd
#Nagios
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.1.1.tar.gz

#Nagios Plugin
wget http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz

#Nrpe Package
wget http://pkgs.fedoraproject.org/repo/pkgs/nrpe/nrpe-2.14.tar.gz/105857720e21674083a6d6be99e102c7/nrpe-2.14.tar.gz
#########

useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios


####
tar zxvf nagios-plugins*
tar zxvf nagios-4.*
tar xvfz nrpe-*
#######

cd
cd nagios-4.*

./configure --with-command-group=nagcmd 

make all; make install; make install-init; make install-config; make install-commandmode; make install-webconf 

cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/

chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

/etc/init.d/nagios start

##################

cd
cd nagios-plugins-2.1.1

./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install 

##################

cd 
cd nrpe-*
./configure
make all
make install-plugin
make install-daemon
make install-daemon-config
make install-xinetd
cd

#################

touch /usr/local/nagios/etc/htpasswd.users

htpasswd -b /usr/local/nagios/etc/htpasswd.users nagiosadmin goenka@2016

/etc/init.d/nagios restart
/etc/init.d/httpd restart
#################
# END OF LINE
##################
