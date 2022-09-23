# Ответы на задание к занятию "3.9. Элементы безопасности информационных систем"
1.
![Pic. 1](pics/bitwarden1.png "Pic. 1")

2. 
![Pic. 2](pics/bitwarden2.png "Pic. 2")
![Pic. 3](pics/bitwarden3.png "Pic. 3")
![Pic. 4](pics/bitwarden4.png "Pic. 4")

3. Настроил проброс портов для ВМ
```console
nano Vagrantfile

  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 443, host: 8443, host_ip: "127.0.0.1"

vagrant up
vagrant ssh
```
```console
vagrant@vagrant:~$ sudo apt install apache2
```
![Pic. 5](pics/apache1.png "Pic. 5")
```console
vagrant@vagrant:~$ sudo a2enmod ssl
vagrant@vagrant:~$ sudo systemctl restart apache2
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=127.0.0.1"
Generating a RSA private key
..........+++++
.............................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
vagrant@vagrant:~$ sudo nano /etc/apache2/sites-available/127.0.0.1.conf

<VirtualHost *:443>   
    ServerName 127.0.0.1
    DocumentRoot /var/www/127.0.0.1
    SSLEngine on   
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>

vagrant@vagrant:~$ sudo mkdir /var/www/127.0.0.1
vagrant@vagrant:~$ echo '<h1>It worked!</h1>' | sudo tee /var/www/127.0.0.1/index.html
vagrant@vagrant:~$ sudo a2ensite 127.0.0.1.conf
Enabling site 127.0.0.1.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@vagrant:~$ sudo apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 127.0.1.1. Set the 'ServerName' directive globally to suppress this message
Syntax OK
vagrant@vagrant:~$ sudo systemctl reload apache2
```
![Pic. 6](pics/apache2.png "Pic. 6")
![Pic. 7](pics/apache3.png "Pic. 7")

4.
```console
vagrant@vagrant:~$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
Cloning into 'testssl.sh'...
remote: Enumerating objects: 104, done.
remote: Counting objects: 100% (104/104), done.
remote: Compressing objects: 100% (97/97), done.
remote: Total 104 (delta 15), reused 39 (delta 6), pack-reused 0
Receiving objects: 100% (104/104), 8.74 MiB | 3.94 MiB/s, done.
Resolving deltas: 100% (15/15), done.
vagrant@vagrant:~$ cd testssl.sh/
vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://www.rambler.ru/        

###########################################################
    testssl.sh       3.2rc1 from https://testssl.sh/dev/
    (33376cc 2022-09-18 21:50:30)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")


 Start 2022-09-23 06:42:24        -->> 81.19.82.98:443 (www.rambler.ru) <<--

 rDNS (81.19.82.98):     www.rambler.ru.
 Service detected:       HTTP

 Pre-test: 128 cipher limit bug

 Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "br gzip" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
                                           https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=7745A7EEAC1C1630B611550EF8E7BF62B21DB267EF3C15C9FFA8DAA63FF62595
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES256-SHA AES128-SHA 
                                           VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-09-23 06:45:17 [ 174s] -->> 81.19.82.98:443 (www.rambler.ru) <<--
```
5.
```console
vagrant@vagrant:~$ sudo apt install openssh-server
vagrant@vagrant:~$ sudo systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-09-23 06:14:32 UTC; 32min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 759 (sshd)
      Tasks: 1 (limit: 2274)
     Memory: 6.5M
     CGroup: /system.slice/ssh.service
             └─759 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
```
```console             
$ ssh-keygen      
Generating public/private rsa key pair.
Enter file in which to save the key (~/.ssh/id_rsa): ~/.ssh/id_vagrant
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ~/.ssh/id_vagrant
Your public key has been saved in ~/.ssh/id_vagrant.pub
The key fingerprint is:
SHA256:FeMP/CqDdcbKpE7qH4ktXqzkIM+FLu7zhrIMZwXAuOE 
The key's randomart image is:
+---[RSA 3072]----+
|+         o      |
|oo       o o     |
|.o.       =      |
|.E .     o +     |
|    .   S + o    |
|   o + B + .     |
|o * = X = .      |
|=X B B . o       |
|=*Bo*.o          |
+----[SHA256]-----+
             
$ ssh-copy-id -f -i ~/.ssh/id_vagrant.pub -p 2222 vagrant@127.0.0.1
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "~/.ssh/id_vagrant.pub"
vagrant@127.0.0.1's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh -p '2222' 'vagrant@127.0.0.1'"
and check to make sure that only the key(s) you wanted were added.

             
$ ssh -i ~/.ssh/id_vagrant -p 2222 vagrant@127.0.0.1
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 23 Sep 2022 06:53:50 AM UTC

  System load:  0.0                Processes:             128
  Usage of /:   12.2% of 30.63GB   Users logged in:       1
  Memory usage: 12%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Sep 23 06:17:20 2022 from 10.0.2.2
vagrant@vagrant:~$ 
```
6.
```console
$ nano ~/.ssh/config
# vagrant
Host 127.0.0.1
  User vagrant
  Port 2222
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_vagrant

$ ssh 127.0.0.1
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 23 Sep 2022 06:59:25 AM UTC

  System load:  0.0                Processes:             125
  Usage of /:   12.2% of 30.63GB   Users logged in:       1
  Memory usage: 11%                IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Sep 23 06:53:50 2022 from 10.0.2.2
vagrant@vagrant:~$ exit
logout
Connection to 127.0.0.1 closed.
```
7.
```console
$ sudo tcpdump -i enx00e04c8a6b33 -c 100 -w enx00e04c8a6b33.pcap
tcpdump: listening on enx00e04c8a6b33, link-type EN10MB (Ethernet), snapshot length 262144 bytes
100 packets captured
268 packets received by filter
0 packets dropped by kernel
```
![Pic. 8](pics/wireshark.png "Pic. 8")
