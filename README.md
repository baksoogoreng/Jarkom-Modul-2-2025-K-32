# Praktikum Modul 2 Jarkom

|No|Nama anggota|NRP|
|---|---|---|
|1. | Tasya Aulia Darmawan | 5027241009|
|2. | Ahmad Rafi F D | 5027241068|

## Soal 1
Eonwe merentangkan tiga jalur:

- **Barat** → Earendil & Elwing  
- **Timur** → Círdan, Elrond, Maglor  
- **DMZ / Pelabuhan** → Sirion, Tirion, Valmar, Lindon, Vingilot  

Konfigurasi IP, gateway, dan DNS disesuaikan dengan glosarium yang diberikan.
![assets/no1.jpg](assets/no1.png)
---

### Soal 1
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.

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
