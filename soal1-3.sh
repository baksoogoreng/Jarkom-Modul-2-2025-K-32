> Eonwe
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

> in CLI
    /etc/resolv.conf
    nameserver 192.168.122.1

    /root/.bashrc
    apt update
    apt install -y iptables
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.227.0.0/16
    echo nameserver 192.168.122.1 > /etc/resolv.conf

> Client Barat (Earendil & Elwing)
auto eth0 (Earendil)
iface eth0 inet static
    address 192.227.1.2
    netmask 255.255.255.0
    gateway 192.227.1.1

auto eth0 (Elwing)
iface eth0 inet static
    address 192.227.1.3
    netmask 255.255.255.0
    gateway 192.227.1.1

> in CLI
    /root/.bashrc
    echo nameserver 192.168.122.1 > /etc/resolv.conf (DNS Resolver)
    echo search K32.com > /etc/resolv.conf
    echo nameserver 192.227.3.3 > /etc/resolv.conf
    echo nameserver 192.227.3.4 > /etc/resolv.conf

    source /root/.bashrc

> Client Timur
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

> in CLI
    /root/.bashrc
    echo nameserver 192.168.122.1 > /etc/resolv.conf (DNS Resolver)
    echo search K32.com > /etc/resolv.conf
    echo nameserver 192.227.3.3 > /etc/resolv.conf
    echo nameserver 192.227.3.4 > /etc/resolv.conf

    source /root/.bashrc

> Zona DMZ (Pelabuhan & Server)
Sirion (Reverse Proxy)
auto eth0
iface eth0 inet static
    address 192.227.3.2
    netmask 255.255.255.0
    gateway 192.227.3.1

Tirion (DNS Utama)
auto eth0
iface eth0 inet static
    address 192.227.3.3
    netmask 255.255.255.0
    gateway 192.227.3.1

Valmar (DNS Bayangan)
auto eth0
iface eth0 inet static
    address 192.227.3.4
    netmask 255.255.255.0
    gateway 192.227.3.1

Lindon (Web Statis)
auto eth0
iface eth0 inet static
    address 192.227.3.5
    netmask 255.255.255.0
    gateway 192.227.3.1

Vingilot (Web Dinamis)
auto eth0
iface eth0 inet static
    address 192.227.3.6
    netmask 255.255.255.0
    gateway 192.227.3.1

> in CLI (each of them)
    /root/.bashrc
    echo nameserver 192.168.122.1 > /etc/resolv.conf (DNS Resolver)
    echo search K32.com > /etc/resolv.conf
    echo nameserver 192.227.3.3 > /etc/resolv.conf
    echo nameserver 192.227.3.4 > /etc/resolv.conf

    source /root/.bashrc


`use: source /root/.bashrc`