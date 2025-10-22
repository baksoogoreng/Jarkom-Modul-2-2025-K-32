> in Lindon
apt update
apt install -y apache2

service apache2 start
service apache2 status

mkdir -p /var/www/static/annals
echo "aku suka suki" > /var/www/static/index.html
echo "ADMINNNNNN aku mawu cindo fineshyt" > /var/www/static/annals/catatan1.txt
echo "Catatan Om Martin bersyukur kepada nasi dingin dengan teri dan kangkung pedas serta para sunda/tomboy fineshyt" > /var/www/static/annals/catatan2.txt

nano /etc/apache2/sites-available/static.K32.com.conf
<VirtualHost *:80>
    ServerAdmin webmaster@K32.com
    ServerName static.K32.com
    ServerAlias static.K32.com

    DocumentRoot /var/www/static

    <Directory /var/www/static>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/static_error.log
    CustomLog ${APACHE_LOG_DIR}/static_access.log combined
</VirtualHost>

service apache2 reload

a2ensite static.K32.com.conf
a2dissite 000-default.conf  # opsional, agar tidak bentrok

service apache2 reload
service apache2 restart
service apache2 status

> in Earendil for checking
curl http://static.K32.com/index.html
curl http://static.K32.com/annals/catatan1.txt
curl http://static.K32.com/annals/catatan2.txt

lynx http://static.K32.com/