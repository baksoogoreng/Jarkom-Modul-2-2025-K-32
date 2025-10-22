> in tirion
nano /etc/bind/zones/db.K32.com
tambahkan di paling bawah :
; Havens www
havens  IN CNAME www.K32.com.

named-checkzone K32.com /etc/bind/zones/db.K32.com
service bind9 reload  ||  service bind9 restart

> in earendil
dig @192.227.3.3 havens.K32.com
;; ANSWER SECTION:
havens.K32.com.  3600 IN CNAME www.K32.com.
www.K32.com.     3600 IN A     192.227.3.2

test http
ping -c 1 havens.K32.com

lynx http://havens.K32.com