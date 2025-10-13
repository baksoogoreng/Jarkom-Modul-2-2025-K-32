//Buka Sirion
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
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;       proxy_set_header Host $host;

        proxy_pass http://192.227.3.6;
    }

    # (Opsional) jika nanti pakai PHP-FPM:
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}


nano /etc/nginx/nginx.conf

<!-- masukkan di http{} -->
log_format proxy_realip '$remote_addr forwarded_for=$proxy_add_x_forwarded_for - $remote_user [$time_local] '
                        '"$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"';

nano /etc/nginx/sites-available/redirect-www.conf
<!-- tambahin right sebelum location \-->
access_log /var/log/nginx/access.log proxy_realip;

<!-- server {
    listen 80;
    listen [::]:80;
    server_name www.K32.com;

    root /var/www/html;
    index index.html index.php;

    # Log IP klien asli
    access_log /var/log/nginx/access.log proxy_realip;

    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;

        proxy_pass http://192.227.3.6;
    }
} -->

nginx -t
service nginx reload

curl -I http://www.K32.com
tail -f /var/log/nginx/access.log
