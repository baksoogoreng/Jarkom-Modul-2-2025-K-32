> in Vingilot
apt update
apt install -y apache2 libapache2-mod-fcgid php php-fpm

a2enmod proxy_fcgi setenvif
a2enconf php*-fpm   # otomatis link ke versi PHP terinstall
a2enmod rewrite

php-fpm8.4 -D
ls -l /run/php/

service apache2 start
service apache2 reload
service apache2 restart
service apache2 status

mkdir -p /var/www/app
nano /var/www/app/index.php
<?php
echo "<h1>mas fuad pengen jadi femboy terus cosplay <strong>hiura mihate</strong></h1>";
echo "<p>Saya lagi membayangkan prabowo mendaki semeru, trus pas nyampe di puncak, dia mengibarkan bendera merah putih lalu dia berteriak, titiekkkkk kembalilah ke pelukanku</p>";
?>

nano /var/www/app/about.php
<?php
echo "<h1>samsul arip, when yh extend.</h1>";
echo "<p>[Verse 1]Bapak Mulyono raja tipu-tipuMobil ESEMKA hanyalah salah satuBanyak fakta banyak bukti ditemuiMulyono serakahnya setengah mati</p>";
?>

php -l /var/www/app/index\about.php <-- to check syntax error

nano /etc/apache2/sites-available/app.K32.com.conf
<VirtualHost *:80>
    ServerAdmin webmaster@K32.com
    ServerName app.K32.com
    ServerAlias app.K32.com

    DocumentRoot /var/www/app

    <Directory /var/www/app>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/app_error.log
    CustomLog ${APACHE_LOG_DIR}/app_access.log combined
</VirtualHost>

a2ensite app.K32.com.conf
a2dissite 000-default.conf   # opsional
service apache2 reload
service apache2 restart

apache2ctl configtest
Syntax OK <-- has to  be this

nano /var/www/app/.htaccess
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^about$ about.php [L]

> in Earendil (testing)
ping app.K32.com <-- for ensure

curl http://app.K32.com/
curl http://app.K32.com/about

lynx http://app.K32.com/