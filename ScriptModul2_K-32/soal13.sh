> in tirion
nano /etc/bind/named.conf.local
> tambah di /etc/bind/named.conf.local
zone "K32.com" {
    type master;
    file "/etc/bind/zones/db.K32.com"; <-- yang ini
};

mkdir -p /etc/bind/zones

nano /etc/bind/zones/db.K32.com
$TTL 1h
@   IN SOA  ns1.k32.com. admin.K32.com. (
        2025101301 ; serial YYYYMMDDNN
        1h
        15m
        1w
        1h )

; Nameservers
    IN NS  ns1.K32.com.
    IN NS  ns2.K32.com.

; A records
ns1     IN A 192.227.3.3
ns2     IN A 192.227.3.4

; Service records
@       IN A 192.227.3.2
www     IN A 192.227.3.2
sirion  IN A 192.227.3.2

named-checkzone K32.com /etc/bind/zones/db.K32.com
named-checkconf
service bind9 restart

dig @localhost www.K32.com A +short
dig @localhost sirion.K32.com A +short
dig @localhost K32.com A +short

> in sirion
service apache2 stop

apt update
apt install -y nginx

nano /etc/nginx/sites-available/redirect-www.conf
# ==========================
# SIRION - Reverse Proxy / Canonical Redirect
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

    # Folder web utama
    root /var/www/html;
    index index.html index.php;

    # Contoh: tes dengan file sederhana
    location / {
        try_files $uri $uri/ =404;
    }

    # (Opsional) jika kamu nanti pakai PHP-FPM:
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

rm /etc/nginx/sites-enabled/default  # hapus default kalau masih ada
ln -s /etc/nginx/sites-available/redirect-www.conf /etc/nginx/sites-enabled/
nginx -t
service nginx restart

> in earendil
nano /etc/hosts
192.227.3.2   K32.com www.K32.com sirion.K32.com
192.227.3.3   ns1.K32.com
192.227.3.4   ns2.K32.com

> test
ping -c 1 K32.com
ping -c 1 www.K32.com
ping -c 1 sirion.K32.com

curl -I http://K32.com
curl -I http://sirion.K32.com
curl -I http://192.227.3.2
curl -I http://www.K32.com

expected answer:
K32.com / sirion.K32.com / IP → 301 redirect ke www.K32.com
www.K32.com → 200 OK
