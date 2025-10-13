> in sirion
mkdir -p /var/www/sirion/admin
echo "inih akun rahasyia admin :p" > /var/www/sirion/admin/index.html

apt update
apt install -y apache2-utils

htpasswd -c /etc/apache2/.htpasswd admin <-- usn admin terserah yng penting confignya nanti usnnya sama
> isi pass : rahasia <-- sebenarnya <terserah>

nano /etc/apache2/sites-available/sirion.K32.com.conf
> ganti semua isinya dengan berikut
<VirtualHost *:80>
    ServerAdmin webmaster@K32.com
    ServerName www.K32.com
    ServerAlias sirion.K32.com

    DocumentRoot /var/www/sirion

    <Directory /var/www/sirion>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    <Location "/admin">
        AuthType Basic
        AuthName "Restricted Area"
        AuthUserFile /etc/apache2/.htpasswd
        Require valid-user
    </Location>

    ProxyPass        /static http://192.227.3.5/
    ProxyPassReverse /static http://192.227.3.5/

    ProxyPass        /app http://192.227.3.6/
    ProxyPassReverse /app http://192.227.3.6/

    RequestHeader set Host "%{HTTP_HOST}s"
    RequestHeader set X-Real-IP "%{REMOTE_ADDR}s"

    ErrorLog ${APACHE_LOG_DIR}/sirion_error.log
    CustomLog ${APACHE_LOG_DIR}/sirion_access.log combined
</VirtualHost>

a2ensite sirion.K32.com.conf
service apache2 reload
service apache2 restart

apache2ctl configtest
Syntax OK  <-- should be this

> in Earendil (testing)
curl -i http://www.K32.com/admin/
> harusnya muncul 401 Unauthorized

curl -i -u admin:rahasia http://www.K32.com/admin/
> gunakan user dan pass yang tadi dibuat