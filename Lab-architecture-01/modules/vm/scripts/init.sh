#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install curl

#install nginx
sudo apt-get install -y nginx
sudo apt-get update

echo $HOSTNAME > /var/www/html/index.nginx-debian.html

systemctl start nginx

