> in tirion
nano /etc/rc.local
#!/bin/sh -e
# rc.local — startup commands here

# Start Bind9 (DNS server)
service bind9 start

exit 0

chmod +x /etc/rc.local
bash -x /etc/rc.local
ps aux | grep named
dig @127.0.0.1 www.K32.com

> in valmar
nano /etc/rc.local
#!/bin/sh -e
# rc.local — startup commands here

# Start Bind9 (DNS server)
service bind9 start

exit 0

chmod +x /etc/rc.local
bash -x /etc/rc.local
ps aux | grep named
dig @127.0.0.1 www.K32.com

> in sirion
nano /etc/rc.local
#!/bin/sh -e
# rc.local — startup commands here

# Start Nginx (reverse proxy / static web)
service nginx start

exit 0

chmod +x /etc/rc.local
bash -x /etc/rc.local
ps aux | grep nginx
curl -I http://www.K32.com
curl -I http://www.K32.com/static/

> in lindon
nano /etc/rc.local
#!/bin/sh -e
# rc.local — startup commands here

# Start Nginx (reverse proxy / static web)
service nginx start

exit 0

chmod +x /etc/rc.local
bash -x /etc/rc.local
ps aux | grep nginx
curl -I http://www.K32.com
curl -I http://www.K32.com/static/

> in vingilot
nano /etc/rc.local
#!/bin/sh -e
# rc.local — startup commands here

# Start PHP-FPM daemon manually (karena systemctl nggak tersedia)
php-fpm8.4 -D

# Start Apache web server
service apache2 start

exit 0

chmod +x /etc/rc.local
bash -x /etc/rc.local
ps aux | grep php-fpm
ps aux | grep apache2
curl -I http://www.K32.com/app/

