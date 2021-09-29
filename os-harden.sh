#!/bin/bash

#Check config files
nano /etc/passwd
nano /etc/login.defs

#Delete media files
find / -name '*.mp3' -type f -delete
find / -name '*.mov' -type f -delete
find / -name '*.mp4' -type f -delete
find / -name '*.avi' -type f -delete
find / -name '*.mpg' -type f -delete
find / -name '*.mpeg' -type f -delete
find / -name '*.flac' -type f -delete
find / -name '*.m4a' -type f -delete
find / -name '*.flv' -type f -delete
find / -name '*.ogg' -type f -delete
find /home -name '*.gif' -type f -delete
find /home -name '*.png' -type f -delete
find /home -name '*.jpg' -type f -delete
find /home -name '*.jpeg' -type f -delete

#Secure the network
ufw status enable

sysctl -n net.ipv4.tcp_syncookies
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward
echo "nospoof on" | sudo tee -a /etc/host.conf

#Do update repositories and then upgrade=
apt-get update
apt-get upgrade -y

#Write current services to a text file
service --status-all >> services.txt


echo "install usb-storage /bin/false" > /etc/modprobe.d/usb-storage.conf

authconfig --passalgo=sha512 --update

nano /etc/pam.d/passwd
password    required    pam_pwquality.so retry=3

nano /etc/security/pwquality.conf
minlen=14 
dcredit=-1  
ucredit=-1  
ocredit=-1  
lcredit=-1 

nano /etc/ssh/sshd_config
Banner /etc/issue.net

nano /etc/pam.d/system-auth
auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=360
auth required pam_faillock.so preauth audit silent deny=5 unlock_time=360
auth [success=1 default=bad] pam_unix.so
auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=360
password sufficient pam_unix.so <remember=5>


nano /etc/sysctl.conf
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.all.accept_source_route=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.icmp_ignore_bogus_error_messages=1
net.ipv4.conf.all.log_martians = 1

net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.accept_ra=0
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
net.ipv6.conf.all.disable_ipv6=1

fs.suid_dumpable = 0
net.ipv4.conf.all.log_martians=1
net.ipv4.conf.default.log_martians=1

/sbin/sysctl -w net.ipv6.conf.all.accept_ra=0
/sbin/sysctl -w net.ipv6.conf.default.accept_ra=0
/sbin/sysctl -w net.ipv6.route.flush=1
/sbin/sysctl -w net.ipv6.conf.all.accept_redirects=0
/sbin/sysctl -w net.ipv6.conf.default.accept_redirects=0
/sbin/sysctl -w net.ipv6.route.flush=1
/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1
/sbin/sysctl -w net.ipv4.conf.all.log_martians=1
/sbin/sysctl -w net.ipv4.conf.default.log_martians=1
/sbin/sysctl -w net.ipv4.route.flush=1

echo "ALL:ALL" >> /etc/hosts.deny 
echo "sshd:ALL" >> /etc/hosts.allow

#yum -y install yum-cron

nano /etc/security/limits.conf
* hard core 0

kernel.exec-shield=1
kernel.randomize_va_space=1


