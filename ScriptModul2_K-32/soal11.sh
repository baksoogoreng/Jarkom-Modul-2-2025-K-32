> in Sirion
apt update
apt install -y apache2
service apache2 start

a2enmod proxy
a2enmod proxy_http
a2enmod headers
a2enmod rewrite

service apache2 reload
service apache2 restart

nano /etc/apache2/sites-available/sirion.K32.com.conf
<VirtualHost *:80>
    ServerAdmin webmaster@K32.com
    ServerName www.K32.com
    ServerAlias sirion.K32.com

    # Reverse Proxy untuk /static ke Lindon
    ProxyPass        /static http://192.227.3.5/
    ProxyPassReverse /static http://192.227.3.5/

    # Reverse Proxy untuk /app ke Vingilot
    ProxyPass        /app http://192.227.3.6/
    ProxyPassReverse /app http://192.227.3.6/

    # Forward header Host dan X-Real-IP ke backend
    RequestHeader set Host "%{HTTP_HOST}s"
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    ErrorLog ${APACHE_LOG_DIR}/sirion_error.log
    CustomLog ${APACHE_LOG_DIR}/sirion_access.log combined
</VirtualHost>

a2ensite sirion.K32.com.conlynf
a2dissite 000-default.conf   # opsional
service apache2 reload
service apache2 restart

apache2ctl configtest
Syntax OK <-- should be this

> in Earendil (testing)
ping www.K32.com
ping sirion.K32.com

curl http://www.K32.com/static/
curl http://www.K32.com/static/annals/catatan1.txt
curl http://www.K32.com/static/annals/catatan2.txt

curl http://www.K32.com/app/
curl http://www.K32.com/app/about