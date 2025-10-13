> in Tirion

nano /etc/bind/jarkom/K32.com
**add**
```
; Barat
earendil   IN  A  192.227.1.2
elwing     IN  A  192.227.1.3

; Timur
cirdan     IN  A  192.227.2.2
elrond     IN  A  192.227.2.3
maglor     IN  A  192.227.2.4
verda      IN  A  192.227.2.5

; DMZ
sirion     IN  A  192.227.3.2
tirion     IN  A  192.227.3.3
valmar     IN  A  192.227.3.4
lindon     IN  A  192.227.3.5
vingilot   IN  A  192.227.3.6
```

rndc reload
service bind9 restart

> in Valmar
ls /var/lib/bind/  ||  rndc retransfer K32.com

check : ping <node>.K32.com <-- harus kecil semua
in every node : (**MUST**)
nano /etc/resolv.conf
search K32.com
nameserver 192.227.3.3
nameserver 192.227.3.4
nameserver 192.168.122.1