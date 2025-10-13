> Cek serial SOA (angka-angka pertama)
> in Tirion
dig @192.227.3.3 K32.com SOA +short

> in Valmar
dig @192.227.3.4 K32.com SOA +short

> Kalo beda
Di Valmar:
rndc retransfer K32.com

service bind9 restart

dig @192.227.3.4 K32.com SOA +short
