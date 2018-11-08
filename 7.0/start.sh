#!/bin/sh

# Handle the IP change
cat /etc/hosts | grep -v "nucleus.host.internal" > /etc/hosts
echo "`/sbin/ip route|awk '/default/ { print $3 }' | grep -v ppp` nucleus.host.internal" | tee -a /etc/hosts > /dev/null

# Run services
nohup /usr/sbin/php-fpm7.0 &
/usr/sbin/apache2ctl -D FOREGROUND