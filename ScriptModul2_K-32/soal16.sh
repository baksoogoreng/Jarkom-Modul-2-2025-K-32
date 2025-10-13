> in Tirion
nano /etc/bind/zones/db.K32.com 
> ubah semuanya
$TTL 1h
@   IN SOA  ns1.k32.com. admin.K32.com. (
        2025101301
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

; Lindon – TTL 30 detik & IP baru
lindon  30 IN A 192.227.3.99

; Static → Lindon
static  IN CNAME lindon.K32.com.

named-checkzone K32.com /etc/bind/zones/db.K32.com
named-checkconf
> kalau ada error,
nano /etc/bind/named.conf.local
zone "K32.com" {
    type master;
    file "/etc/bind/jarkom/K32.com";  # ❌ hapus ini
    file "/etc/bind/zones/db.K32.com";   # ✅ hanya satu
    allow-transfer { 192.227.3.4; };     # Valmar (ns2)
    notify yes;
};

zone "3.227.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.227.192.in-addr.arpa";
    allow-transfer { 192.227.3.4; };
    notify yes;
};

named-checkzone K32.com /etc/bind/zones/db.K32.com
named-checkconf
service bind9 reload  ||  service bind9 restart

ps aux | grep named
dig @127.0.0.1 www.K32.com
