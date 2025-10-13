> in Tirion
nano /etc/bind/named.conf.local
zone "3.227.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.227.192.in-addr.arpa";
    allow-transfer { 192.227.3.4; };   // Valmar (ns2)
    notify yes;
};

nano /etc/bind/jarkom/3.227.192.in-addr.arpa
$TTL    604800
@       IN      SOA     ns1.K32.com. root.K32.com. (
                        2025101301  ; Serial
                        604800      ; Refresh
                        86400       ; Retry
                        2419200     ; Expire
                        604800 )    ; Negative Cache TTL

; NS Records
@       IN      NS      ns1.K32.com.
@       IN      NS      ns2.K32.com.

; PTR Records
2       IN      PTR     sirion.K32.com.
5       IN      PTR     lindon.K32.com.
6       IN      PTR     vingilot.K32.com.

named-checkzone 3.227.192.in-addr.arpa /etc/bind/jarkom/3.227.192.in-addr.arpa
rndc reload

> in Valmar
nano /etc/bind/named.conf.local
zone "3.227.192.in-addr.arpa" {
    type slave;
    primaries { 192.227.3.3; };   // Master = Tirion
    file "/var/lib/bind/3.227.192.in-addr.arpa";
};

service bind9 restart
ls -l /var/lib/bind/3.227.192.in-addr.arpa

> verification
> in earandil
dig -x 192.227.3.2
dig -x 192.227.3.5
dig -x 192.227.3.6

;; ANSWER SECTION:
2.3.227.192.in-addr.arpa. 604800 IN PTR sirion.K32.com.
5.3.227.192.in-addr.arpa. 604800 IN PTR lindon.K32.com.
6.3.227.192.in-addr.arpa. 604800 IN PTR vingilot.K32.com.
and
;; flags: qr aa rd ra; ...

> in Tirion
dig @192.227.3.3 3.227.192.in-addr.arpa SOA +short

> in Velmar
dig @192.227.3.4 3.227.192.in-addr.arpa SOA +short

serial zone must be identical.