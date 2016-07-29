#!/bin/bash
# This should enable to install webpanel required.
# to run this script be in your own home directory.
# to run on fresh install only. 
sudo su
apt-get update -y
apt-get upgrade -y
apt-get -y install git python-virtualenv python-dev libxml2-dev libvirt-dev zlib1g-dev nginx supervisor libsasl2-modules
git clone https://github.com/retspen/webvirtcloud
cd webvirtcloud
sudo cp conf/supervisor/webvirtcloud.conf /etc/supervisor/conf.d
sudo cp conf/nginx/webvirtcloud.conf /etc/nginx/conf.d
cd ..
sudo mv webvirtcloud /srv
sudo chown -R www-data:www-data /srv/webvirtcloud
cd /srv/webvirtcloud
virtualenv venv
source venv/bin/activate
pip install -r conf/requirements.txt
python manage.py migrate
sudo chown -R www-data:www-data /srv/webvirtcloud
sudo rm /etc/nginx/sites-enabled/default
#
service nginx restart
service supervisor restart
# Likely to fail this command ( below ) - better to ignore. 
usermod -G kvm -a webvirtmgr
supervisorctl status
# Install final required packages for libvirtd and others on Host Server
