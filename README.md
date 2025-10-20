
# Laporan Resmi Praktikum Modul 2 Jarkom

|No|Nama anggota|NRP|
|---|---|---|
|1. | Tasya Aulia Darmawan | 5027241009|
|2. | Ahmad Rafi F D | 5027241068|

## Soal 1-3
Eonwe merentangkan tiga jalur:

- **Barat** → Earendil & Elwing  
- **Timur** → Círdan, Elrond, Maglor  
- **DMZ / Pelabuhan** → Sirion, Tirion, Valmar, Lindon, Vingilot  

Konfigurasi IP, gateway, dan DNS disesuaikan dengan glosarium yang diberikan.
![assets/no1.jpg](assets/no1.png)
---

### Soal 1
Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.

---

### 1. Eonwe (Router / NAT)

```bash
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.227.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.227.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.227.3.1
    netmask 255.255.255.0

up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.227.0.0/16

echo nameserver 192.168.122.1 > /etc/resolv.conf

apt update
apt install -y iptables
```

### /etc/resolv.conf
```
nameserver 192.168.122.1
```

### /root/.bashrc
```
# ======== TOOLS INSTALLER ========
apt update
apt install -y iptables

# ======== DNS Resolver ========
echo nameserver 192.168.122.1 > /etc/resolv.conf

# ======== NAT Masquerading ========
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.227.0.0/16
```

### 2. Client Barat (Earendil & Elwing)
```
# Earendil
auto eth0
iface eth0 inet static
    address 192.227.1.2
    netmask 255.255.255.0
    gateway 192.227.1.1

# Elwing
auto eth0
iface eth0 inet static
    address 192.227.1.3
    netmask 255.255.255.0
    gateway 192.227.1.1

echo nameserver 192.168.122.1 > /etc/resolv.conf
```

### /root/.bashrc
```
echo nameserver 192.168.122.1 > /etc/resolv.conf  # DNS Resolver
```

### 3. Client Timur
```
auto eth0
iface eth0 inet static
    address 192.227.2.2
    netmask 255.255.255.0
    gateway 192.227.2.1

auto eth0
iface eth0 inet static
    address 192.227.2.3
    netmask 255.255.255.0
    gateway 192.227.2.1

auto eth0
iface eth0 inet static
    address 192.227.2.4
    netmask 255.255.255.0
    gateway 192.227.2.1
```
### /root/.bashrc
```
echo nameserver 192.168.122.1 > /etc/resolv.conf  # DNS Resolver
```

### 4. Zona DMZ (Pelabuhan & Server)
#### a) Sirion (Reverse Proxy)
```
auto eth0
iface eth0 inet static
    address 192.227.3.2
    netmask 255.255.255.0
    gateway 192.227.3.1
```
#### b) Tirion (DNS Utama)
```
auto eth0
iface eth0 inet static
    address 192.227.3.3
    netmask 255.255.255.0
    gateway 192.227.3.1
```
#### c) Valmar (DNS Bayangan)
```
auto eth0
iface eth0 inet static
    address 192.227.3.4
    netmask 255.255.255.0
    gateway 192.227.3.1
```
#### d) Lindon (Web Statis)
```
auto eth0
iface eth0 inet static
    address 192.227.3.5
    netmask 255.255.255.0
    gateway 192.227.3.1
```
#### e) Vingilot (Web Dinaris)
```
auto eth0
iface eth0 inet static
    address 192.227.3.6
    netmask 255.255.255.0
    gateway 192.227.3.1
```
### /root/.bashrc
```
echo nameserver 192.168.122.1 > /etc/resolv.conf  # DNS Resolver
```

### Soal 4
Membangun sistem DNS authoritative di Tirion (ns1) sebagai master dan Valmar (ns2) sebagai slave untuk domain K32.com, lengkap dengan konfigurasi zona, transfer antar-server, dan pengaturan resolver agar seluruh host menggunakan ns1 dan ns2 sebagai DNS utama.

---
### 1. Tirion (ns1 / Master)
```
apt update
apt install -y bind9
ln -s /etc/init.d/named /etc/init.d/bind9
```
Konfigurasi zona K32.com sebagai master
```
nano /etc/bind/named.conf.local
```
Isi File:
```
zone "K32.com" {
    type master;
    file "/etc/bind/jarkom/K32.com";
    allow-transfer { 192.227.3.4; };  // IP Valmar (ns2)
    notify yes;
};
```
Konfigurasi resolver
```
nano /etc/resolv.conf
```
Isi File:
```
search K32.com
nameserver 192.227.3.3   # ns1 (Tirion)
nameserver 192.227.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
```
Direktori zona dan isi file zona
```
mkdir -p /etc/bind/jarkom
nano /etc/bind/jarkom/K32.com
```
Isi file zona:
```
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
```
Konfigurasi forwarder agar DNS bisa resolve ke luar
```
nano /etc/bind/named.conf.options
```
Isi file:
```
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    allow-query { any; };
    dnssec-validation auto;
    listen-on-v6 { any; };
};
```
---
Restart & Cek Status
```
service bind9 restart
service bind9 status
```
### 2. Valmar (ns2 / Slave)
```
apt update
apt install -y bind9
ln -s /etc/init.d/named /etc/init.d/bind9

nano /etc/bind/named.conf.local
```
Isi file:
```
zone "K32.com" {
    type slave;
    primaries { 192.227.3.3; };     # Master = Tirion
    file "/var/lib/bind/K32.com";   # Zona disimpan otomatis
};
```
Konfigurasi Resolver:
```
nano /etc/resolv.conf
```
Isi file:
```
search K32.com
nameserver 192.227.3.3   # ns1 (Tirion)
nameserver 192.227.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
```
---
Restart & Cek Status
```
service bind9 restart
service bind9 status
```
Verifikasi Authoritative DNS
```
# Tes query dari client mana pun (misal Earendil)
dig @192.227.3.3 K32.com      # Jawaban dari ns1 (master)
dig @192.227.3.4 K32.com      # Jawaban dari ns2 (slave)
```
### Soal 5
Memberi hostname pada seluruh node sesuai glosarium dan menambahkan A record tiap host dalam zona K32.com agar semua perangkat dapat saling mengenali menggunakan nama domain masing-masing secara system-wide, kecuali untuk node ns1 dan ns2.

---
### 1. Konfigurasi di Tirion (ns1/master)
Edit file zona K32.com:
```
nano /etc/bind/jarkom/K32.com
```
Tambahkan konfigurasi berikut:
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
---
Reload & Restart Service BIND
```
rndc reload
service bind9 restart
```
### 2. Konfigurasi di Valmar (ns2/slave)
Periksa apakah zona sudah tersinkron
```
ls /var/lib/bind/
```
Jika belum ada file K32.com, jalankan
```
rndc retransfer K32.com
```
Lakukan ping ke setiap host untuk memastikan DNS resolve berjalan:
```
ping earendil.K32.com
ping elwing.K32.com
ping cirdan.K32.com
ping elrond.K32.com
ping maglor.K32.com
ping sirion.K32.com
ping tirion.K32.com
ping valmar.K32.com
ping lindon.K32.com
ping vingilot.K32.com
```
Update resolver di setiap node
```
nano /etc/resolv.conf
```
Isi dengan:
```
search K32.com
nameserver 192.227.3.3   # ns1 (Tirion)
nameserver 192.227.3.4   # ns2 (Valmar)
nameserver 192.168.122.1
```
### Soal 6


---
### 1. K
Ed
