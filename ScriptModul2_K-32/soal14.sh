> in Sirion
nano /etc/nginx/nginx.conf
<!-- masukkan di http{} -->
log_format proxy_realip '$remote_addr forwarded_for=$proxy_add_x_forwarded_for - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"';

DAN PASTIKAN DIATAS access_log /var/log/nginx/access.log; DI nginx.conf

nano /etc/nginx/sites-available/redirect-www.conf
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    # Redirect 301 ke host kanonik
    return 301 http://www.K32.com$request_uri;
}

# === Block 2: Host utama (kanonik) www.K32.com ===
server {
    listen 80;
    listen [::]:80;
    server_name www.K32.com;

    # Folder web utama
    root /var/www/html;
    index index.html index.php;

    location / {               
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;

        proxy_pass http://192.227.3.6;
    }

    # (Opsional) jika nanti pakai PHP-FPM:
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

nginx -t
service nginx reload

> in Vingilot
apt update
apt install -y nginx

service apache2 stop

nano /etc/nginx/nginx.conf
<!-- masukkan di http{} -->
log_format proxy_realip '$remote_addr forwarded_for=$proxy_add_x_forwarded_for - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"';

DAN PASTIKAN DIATAS access_log /var/log/nginx/access.log; DI nginx.conf

nano /etc/nginx/sites-available/redirect-www.conf
server {
    listen 80;
    listen [::]:80;
    server_name www.K32.com;

    root /var/www/html;
    index index.html index.php;

    access_log /var/log/nginx/access.log proxy_realip;

    location / {
        try_files $uri $uri/ =404;
    }
}

nginx -t
service nginx reload

> in Earendil (testing)
curl -I http://www.K32.com

> in Vingilot (to see the logs)
tail -f /var/log/nginx/access.log
