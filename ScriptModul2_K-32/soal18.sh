> in tirion
nano /etc/bind/zones/db.K32.com
tambahkan di paling bawah:
; Melkor - TXT & CNAME
melkor   IN TXT   "Morgoth (Melkor)"
morgoth  IN CNAME melkor.K32.com.

named-checkzone K32.com /etc/bind/zones/db.K32.com
service bind9 reload  ||  service bind9 restart

> in earandil
dig @192.227.3.3 TXT melkor.K32.com
;; ANSWER SECTION:
melkor.K32.com.   3600 IN TXT "Morgoth (Melkor)"

dig @192.227.3.3 morgoth.K32.com
;; ANSWER SECTION:
morgoth.K32.com.  3600 IN CNAME melkor.K32.com.
melkor.K32.com.   3600 IN TXT "Morgoth (Melkor)"

> in valmar
dig @192.227.3.4 TXT melkor.K32.com
dig @192.227.3.4 morgoth.K32.com

pastiin SOA di ns1 dan ns2 sama