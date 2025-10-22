> in Tirion
nano /etc/bind/jarkom/K32.com
; DMZ / Web related records
sirion      IN  A       192.227.3.2
lindon      IN  A       192.227.3.5
vingilot    IN  A       192.227.3.6 (udah seharusnya)

; CNAME Records
www         IN  CNAME   sirion.K32.com. <-- yang A di comment (;)
static      IN  CNAME   lindon.K32.com.
app         IN  CNAME   vingilot.K32.com.

rndc reload  ||  service bind9 restart
dig @192.227.3.4 K32.com SOA +short

> in Valmar
rndc retransfer K32.com
dig @192.227.3.4 K32.com SOA +short

check the serial zone, both has to be the same

> check in other node, earandil
dig sirion.K32.com
dig www.K32.com
dig lindon.K32.com
dig static.K32.com
dig vingilot.K32.com
dig app.K32.com

expected result:
sirion.K32.com.   IN A      192.227.3.2
www.K32.com.      IN CNAME  sirion.K32.com.
                  IN A      192.227.3.2

lindon.K32.com.   IN A      192.227.3.5
static.K32.com.   IN CNAME  lindon.K32.com.
                  IN A      192.227.3.5

vingilot.K32.com. IN A      192.227.3.6
app.K32.com.      IN CNAME  vingilot.K32.com.
                  IN A      192.227.3.6
