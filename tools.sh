#! /bin/bash

# Upgrade repositories
sudo apt-get update

# Install tools for my pentests
sudo apt-get install -y curl nikto hydra sqlmap nmap hashcat netcat john yersinia aircrack-ng ssh vsftpd wireshark snort cadaver atftpd

# Some tools neccesaries
sudo apt-get install -y postgresql apache2 php

# Spoofing tools
sudo apt-get install -y dsniff exiftool net-tools ettercap-graphical steghide binwalk smbclient dnsrecon recon-ng

# Kali Linux repositories
sudo apt-get install gnupg -y
sudo sh -c "echo 'deb https://http.kali.org/kali kali-rolling main non-free contrib' > /etc/apt/sources.list.d/kali.list"
sudo apt-get update -y
wget 'https://archive.kali.org/archive-key.asc'
sudo apt-key add archive-key.asc
sudo apt-get update -y
sudo sh -c "echo 'Package: *'>/etc/apt/preferences.d/kali.pref; echo 'Pin: release a=kali-rolling'>>/etc/apt/preferences.d/kali.pref; echo 'Pin-Priority: 50'>>/etc/apt/preferences.d/kali.pref"
sudo apt-get update -y

sudo apt-get install exploitdb -y

sudo apt autoremove && sudo apt-get update -y
sudo rm arch*

curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
rm msfinstall
