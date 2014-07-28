#!/bin/bash
# Script to setup lumberjack on Ubuntu machine

set -e

apt-get update
apt-get -y install unzip

# Lumberjack source
wget https://github.com/elasticsearch/logstash-forwarder/archive/master.zip
unzip master.zip
cd logstash-forwarder-master

# basic build stuff
apt-get -y install build-essential

# GO
apt-get -y install python-software-properties
apt-add-repository -y ppa:duh/golang
apt-get update
apt-get -y install golang

apt-get -y install ruby rubygems ruby-dev
gem install fpm
umask 022
make deb

#fpm -s dir -t deb -n logstash-forwarder -v 0.3.1 --prefix /opt/logstash-forwarder \
#    --exclude '*.a' --exclude 'lib/pkgconfig/zlib.pc' -C build \
#    --description "a log shipping tool" \
#    --url "https://github.com/elasticsearch/logstash-forwarder" \
#    bin/logstash-forwarder bin/logstash-forwarder.sh lib

dpkg -i `ls *.deb`


mkdir /etc/logstash-forwarder
cp /vagrant/key/server.crt /etc/logstash-forwarder
cp /vagrant/logstash-forwarder.conf /etc/logstash-forwarder/logstash-forwarder.conf
cp /vagrant/logstash-forwarder.init /etc/init.d/logstash-forwarder
chmod 755 /etc/init.d/logstash-forwarder
cp /vagrant/logstash-forwarder.default /etc/default/logstash-forwarder
/etc/init.d/logstash-forwarder start




