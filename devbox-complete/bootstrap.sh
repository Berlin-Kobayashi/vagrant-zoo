#!/usr/bin/env bash

# enable colorful terminal
sed -i 's/^.*force_color_prompt=yes.*/force_color_prompt=yes/' .bashrc
source .bashrc

# install apache2
sudo apt-get update
sudo apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi

# enable apache2 rewrite module
sudo a2enmod rewrite
sudo service apache2 restart

# install php 5.6
sudo add-apt-repository -y ppa:ondrej/php5-5.6
sudo apt-get update
sudo apt-get install -y python-software-properties
sudo apt-get install -y php5

# install Git
sudo apt-get install -y git

# install common command line tools
git clone https://github.com/DanShu93/common-command-line-tools.git /home/vagrant/common-command-line-tools

# enable .htaccess
sudo php /home/vagrant/common-command-line-tools/apache2/htaccessEnabler.php
sudo service apache2 restart

# install composer
curl -sS https://getcomposer.org/installer | sudo -H php -- --install-dir=/usr/local/bin --filename=composer

# install Symfony installer
sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

# install node.js 5
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

# install grunt-cli globally
sudo npm install -g grunt-cli

# install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
sudo apt-get -y install mysql-server

# install MYSQL PHP extension
sudo apt-get install php5-mysql
sudo service apache2 restart

# install MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# open MongoDB port for everyone
sudo iptables -A INPUT -p tcp --dport 27017 -j ACCEPT
sudo sed -i 's/^  bindIp: 127\.0\.0\.1$/#  bindIp: 127\.0\.0\.1/' /etc/mongod.conf
sudo service mongod restart

# install MongoDB PHP extension
sudo apt-get install php5-mongo
sudo service apache2 restart

# install golang
curl -O https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz
tar -xvf go1.5.3.linux-amd64.tar.gz
sudo mv go /usr/local
rm go1.5.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/vagrant/.bashrc
mkdir goground
echo 'export GOPATH=$HOME/goground' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# install Java 8 JDK
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y oracle-java8-set-default

#install Maven
apt-cache search maven
sudo apt-get install -y maven