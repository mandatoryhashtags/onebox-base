# Carbon OneBox Container Development Environment
# cschrum/onebox-base:7.0


# We are using Ubuntu because using linux is more performant than just using the base php:apache versions
# It also gives us a lot more control down the road as we can customize precisely what is installed
# With the eventual goal of matching client support systems

# Image name
FROM ubuntu:18.04

# Label for who maintains this repo
LABEL "maintainer"="Curtis Schrum <cjschrum@gmail.com>"

# Setup base packages, repo info, etc
RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y \
whois \
sudo \
vim \
htop \
software-properties-common \
sendmail \
git \
iproute2 \
iputils-ping \
lsof \
wget \
mysql-client \
libssl1.1 \
openssl \
openssh-server \
openssh-client

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update

# Install required packages - These packages will need to be updated based on PHP version
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
apache2 \
apache2-bin \
apache2-data \
apache2-utils \
libapache2-mod-fcgid \
libapache2-mod-php7.0 \
php-xdebug \ 
curl \
php7.0-bcmath \
php7.0-cli \
php7.0-common \
php7.0-curl \
php7.0-fpm \
php7.0-gd \ 
php7.0-intl \
php7.0-json \
php7.0-mbstring \
php7.0-mcrypt \
php7.0-mysql \
php7.0-opcache \
php7.0-readline \ 
php7.0-soap \
php7.0-xml \
php7.0-xsl \
mariadb-client \
php7.0-zip

# Install Node, NVM, NPM and Grunt
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn

# Install Composer

RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Configure OpenSSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=Missouri/L=Springfield/O=Security/OU=Development/CN=example.local"

# Install N98 Magerun
RUN wget https://files.magerun.net/n98-magerun2.phar \
	&& chmod +x ./n98-magerun2.phar \
	&& mv ./n98-magerun2.phar /usr/local/bin/n98-magerun.phar

# Setup PHP
RUN mkdir /run/php
RUN touch /run/php/php-fpm.sock

RUN a2enmod php7.0

# Setup apache
RUN ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load
RUN ln -s /etc/apache2/mods-available/proxy_fcgi.load /etc/apache2/mods-enabled/proxy_fcgi.load
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load

RUN /etc/init.d/apache2 restart

# Create new user
RUN useradd -m -p `mkpasswd "nucleus"` -s /bin/bash nucleus
RUN adduser nucleus sudo
RUN ln -s /var/www/html /home/nucleus/html
RUN echo "alias php-debug='php -d xdebug.remote_autostart=1'" > /home/nucleus/.bash_aliases

# Add custom configuration
ADD .docker/config/fpm.conf /etc/php/7.0/fpm/pool.d/www.conf

# Configuration
COPY .docker/config/sites-available/* /etc/apache2/sites-available/
ADD .docker/config/custom-xdebug.ini /usr/local/etc/php/conf.d/custom-xdebug.ini
COPY .docker/bin/* /usr/local/bin/
COPY .docker/users/* /var/www/
RUN chmod +x /usr/local/bin/*
RUN ln -sf /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/


# Add custom scripts
ADD start.sh /start.sh
ADD .docker/scripts/robo.phar /usr/bin/robo.phar

RUN chmod 755 /start.sh
RUN chmod 755 /usr/bin/robo.phar

# Cleanup
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

WORKDIR /var/www/html


CMD ["/start.sh"]