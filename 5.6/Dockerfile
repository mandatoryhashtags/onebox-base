# Carbon OneBox Container Development Environment
# cschrum/onebox-base:5.6


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
RUN apt-get install -y whois sudo vim htop software-properties-common sendmail git iproute2 iputils-ping lsof
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update

# Install required packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 apache2-bin apache2-data apache2-utils libapache2-mod-fcgid php-xdebug mariadb-client curl

# These packages will need to be updated based on PHP version
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php5.6-bcmath php5.6-cli php5.6-common php5.6-curl php5.6-fpm php5.6-gd php5.6-intl php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-opcache php5.6-readline php5.6-soap php5.6-xml php5.6-xsl php5.6-zip


# Install Node, NVM, NPM and Grunt
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn

# Install Composer

RUN	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
RUN composer global require hirak/prestissimo

# Install OpenSSL
RUN apt-get install openssl	

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/ssl-cert-snakeoil.key -out /etc/ssl/certs/ssl-cert-snakeoil.pem -subj "/C=US/ST=Missouri/L=Springfield/O=Security/OU=Development/CN=example.local"


RUN a2enmod rewrite
RUN a2ensite default-ssl
RUN a2enmod ssl

# Setup PHP
RUN mkdir /run/php
RUN touch /run/php/php-fpm.sock

# Setup apache
RUN ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load
RUN ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/headers.load
RUN ln -s /etc/apache2/mods-available/proxy_fcgi.load /etc/apache2/mods-enabled/proxy_fcgi.load
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf
RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load

#SSH
RUN apt-get update && apt-get install -y openssh-server openssh-client
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN /etc/init.d/apache2 restart

# Create new user
RUN useradd -m -p `mkpasswd "nucleus"` -s /bin/bash nucleus
RUN adduser nucleus sudo
RUN ln -s /var/www/html /home/nucleus/html
RUN echo "alias php-debug='php -d xdebug.remote_autostart=1'" > /home/nucleus/.bash_aliases

