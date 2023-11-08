#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install git -y
sudo apt install apache2 -y
cd /var/www/html/
sudo rm -rf *
sudo git clone https://github.com/dillu143/sample.git /var/www/html/
sudo apt install php -y
sudo apt install mysql* -y
sudo systemctl restart apache2
sudo apt install mariadb* -y
