> in Tirion (ns1/master)
apt update
apt install -y bind9
ln -s /etc/init.d/named /etc/init.d/bind9

nano /etc/bind/named.conf.local
zone "K32.com" {
    type master;
    file "/etc/bind/jarkom/K32.com";
    allow-transfer { 192.227.3.4; };  // IP Valmar (ns2)
    notify yes;
};

nano /etc/resolv.conf
search K32.com
nameserver 192.227.3.3   # ns1 (Tirion)
nameserver 192.227.3.4   # ns2 (Valmar)
nameserver 192.168.122.1

mkdir -p /etc/bind/jarkom
nano /etc/bind/jarkom/K32.com
$TTL    604800
@       IN      SOA     ns1.K32.com. root.K32.com. (
                        2025101201 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

; Nameserver
@       IN      NS      ns1.K32.com.
@       IN      NS      ns2.K32.com.

; A Record
ns1     IN      A       192.227.3.3
ns2     IN      A       192.227.3.4
@       IN      A       192.227.3.2   ; Sirion
www     IN      A       192.227.3.2   ; Sirion

nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    dnssec-validation auto;
    listen-on-v6 { any; };
};

service bind9 restart
service bind9 status

> in Valmar (ns2/slave)
apt update
apt install -y bind9
ln -s /etc/init.d/named /etc/init.d/bind9

nano /etc/bind/named.conf.local
zone "K32.com" {
    type slave;
    primaries { 192.227.3.3; };     // Master = Tirion
    file "/var/lib/bind/K32.com";   // Zona disimpan otomatis di sini
};

nano /etc/resolv.conf
search K32.com
nameserver 192.227.3.3   # ns1 (Tirion)
nameserver 192.227.3.4   # ns2 (Valmar)
nameserver 192.168.122.1

service bind9 restart
service bind9 status

authoritative test
dig @192.227.3.3/4 K32.com
