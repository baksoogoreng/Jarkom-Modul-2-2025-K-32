> in sirion
nano /var/www/html/index.html
> ganti semuanya jadi:
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>War of Wrath: Lindon bertahan</title>
  <style>
    body {
      background-color: #f0f2f5;
      font-family: "Segoe UI", Tahoma, sans-serif;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
    }
    h1 {
      color: #2c3e50;
      font-size: 2em;
      margin-bottom: 0.5em;
    }
    p {
      color: #555;
      margin-bottom: 1.5em;
    }
    a {
      display: inline-block;
      margin: 0 10px;
      padding: 10px 20px;
      background-color: #2980b9;
      color: #fff;
      text-decoration: none;
      border-radius: 5px;
      transition: background 0.3s;
    }
    a:hover {
      background-color: #1f5d82;
    }
  </style>
</head>
<body>
  <h1>War of Wrath: Lindon bertahan</h1>
  <p>Selamat datang di gerbang Sirion — jelajahi arsip dan aplikasi di bawah ini:</p>
  <div>
    <a href="/app">Menuju Aplikasi Vingilot (/app)</a>
    <a href="/static">Jelajahi Arsip Lindon (/static)</a>
  </div>
</body>
</html>

nano /etc/nginx/sites-available/redirect-www.conf
> ganti semua isinya dengan berikut
# ==========================
# SIRION - Reverse Proxy + Canonical Redirect + Homepage
# ==========================

# === Block 1: Redirect semua akses non-kanonik ke www.K32.com ===
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

    # Folder web utama (halaman War of Wrath)
    root /var/www/html;
    index index.html index.php;

    # Logging
    access_log /var/log/nginx/www.access.log;
    error_log /var/log/nginx/www.error.log;

    # === Halaman depan ===
    location / {
        try_files $uri $uri/ =404;
    }

    # === Reverse proxy ke Lindon (/static) ===
    location /static {
        proxy_pass http://192.227.3.5/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # === Reverse proxy ke Vingilot (/app) ===
    location /app {
        proxy_pass http://192.227.3.6/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # (Opsional) PHP handler lokal, kalau perlu jalankan PHP di Sirion
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}


nginx -t
service nginx reload

> in Earendil (testing)
ping -c 1 www.K32.com
curl http://www.K32.com/
curl http://www.K32.com/app
curl http://www.K32.com/static/
