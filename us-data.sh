#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum -y install git
sudo yum -y install mysql*
sudo yum install php-gd php-json php-mbstring php-mysqlnd php-opcache php-pdo php-pecl-igbinary -y
sudo amazon-linux-extras install php8.2 -y
sudo git clone https://github.com/dillu143/sample.git /var/www/html/
sudo systemctl restart httpd
