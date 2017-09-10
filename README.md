# UbuntuAfterConf
Set of bash scripts to automate the configuration of the freshly install Ubuntu 16.04 LTS


# Installation of the Ubuntu 16.04 LTS

> - Install Ubuntu without internet connection
- Whenever possible check the mdsums of the downloaded apps.  

### Installation process  
- __Welcome__  
  - _English_
- __Installation Type__
  - _Encrypt the new Ubuntu installation for security_
  - _Use LVM with the new Ubuntu installation_
- __Where are you?__
    - _Chisinau_
- __Keyboard layout__
  - _English (US) - English (US)_
- __Who are you?__
  - _Require my password to log in_
  - _Encrypt my home folder_

### Configuration
###### At this point there will be still no internet connection
Wait for the Ubuntu asking to save the passphrase for the encrypted home directory. When the window will popup just press "Run this action now" and enter you user's password in the automatically opened terminal. Then save somewhere the passphrase. It's needed when restoring access to the home folder.  

9e901bcb836c4d614cc8d09358a81caa

1. Disable Telemetry
- System Settings -> Security and Privacy -> Diagnostics
https://github.com/butteff/Ubuntu-Telemetry-Free-Privacy-Secure

2. Enable the main repository server as well as enabling Multiverse and Universe repositories
cp /etc/apt/sources.list /etc/apt/sources.list.bckp;
echo "# deb cdrom:[Ubuntu 16.04.3 LTS _Xenial Xerus_ - Release amd64 (20170801)]/ xenial main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://archive.ubuntu.com/ubuntu xenial main restricted
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://archive.ubuntu.com/ubuntu xenial-updates main restricted
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu xenial universe
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial universe
deb http://archive.ubuntu.com/ubuntu xenial-updates universe
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://archive.ubuntu.com/ubuntu xenial multiverse
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial multiverse
deb http://archive.ubuntu.com/ubuntu xenial-updates multiverse
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse
# deb-src http://md.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
deb http://archive.canonical.com/ubuntu xenial partner
# deb-src http://archive.canonical.com/ubuntu xenial partner

deb http://archive.ubuntu.com/ubuntu xenial-security main restricted
# deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted
deb http://archive.ubuntu.com/ubuntu xenial-security universe
# deb-src http://security.ubuntu.com/ubuntu xenial-security universe
deb http://archive.ubuntu.com/ubuntu xenial-security multiverse
# deb-src http://security.ubuntu.com/ubuntu xenial-security multiverse" > /etc/apt/sources.list;


3. UFW
cp /etc/ufw/ufw.conf /etc/ufw/ufw.conf.bckp;
echo "IPV6=no" >> /etc/ufw/ufw.conf;
ufw default deny outgoing && ufw default deny incoming && ufw enable;
ufw status verbose;
ufw allow out 80/tcp && ufw allow out 443/tcp && ufw allow out 443/udp && ufw allow out 53/udp && ufw allow out 123/udp && ufw allow out 43/tcp;


cp /etc/ufw/ufw.conf /etc/ufw/ufw.conf.bckp && echo "IPV6=no" >> /etc/ufw/ufw.conf && ufw default deny outgoing && ufw default deny incoming && ufw enable && ufw status verbose && ufw allow out 80/tcp && ufw allow out 443/tcp && ufw allow out 443/udp && ufw allow out 53/udp && ufw allow out 123/udp && ufw allow out 43/tcp

UFW

To                         Action      From
--                         ------      ----
DNS 53/udp                     ALLOW OUT   Anywhere
http  80/tcp                     ALLOW OUT   Anywhere
https 443/tcp                    ALLOW OUT   Anywhere
Pentru sincronizare cu NTP servere 123/udp                    ALLOW OUT   Anywhere
Pentru aplicația whois  43/tcp                     ALLOW OUT   Anywhere
pentru DNSCrypt-proxy 443/udp                     ALLOW OUT   Anywhere

TCP_OUT = "20,21,22,25,53,80,110,113,443"
UDP_OUT = "20,21,53,113,123"

    Port 20: FTP data transfer
    Port 21: FTP control
    Port 22: Secure shell (SSH)
    Port 25: Simple mail transfer protocol (SMTP)
    Port 53: Domain name system (DNS)
    Port 80: Hypertext transfer protocol (HTTP)
    Port 110: Post office protocol v3 (POP3)
    Port 113: Authentication service/identification protocol
    Port 123: Network time protocol (NTP)
    Port 143: Internet message access protocol (IMAP)
    Port 443: Hypertext transfer protocol over SSL/TLS (HTTPS)
    Port 465: URL Rendesvous Directory for SSM (Cisco)
    Port 587: E-mail message submission (SMTP)
    Port 993: Internet message access protocol over SSL (IMAPS)
    Port 995: Post office protocol 3 over TLS/SSL (POP3S)


3. ESET
_libc6:i386_ library is needed for the ESET AV to start installation pocess.  
`apt -y update && apt -y install libc6:i386`

Verify shasum
Install manually as root user
I am showing only the modified steps.
Custom
Let "Enable ThreatSense.Net Early Warning System" checked. Press "Setup" button and disable the "Submission of Suspicious Files" as well as the "Submission of Anonymous Statistical Information".  
Enable detection of ptoentially unwanted applications.  
Restart the system as the installation software sugests.  


### First things first: Update/Upgrade
Right after installation ones should run the following commands
`apt -y update && apt -y upgrade && apt -y dist-upgrade`

4. CLI Apps
`apt -y install screen mc htop iptraf ntp ntpdate tmux unattended-upgrades rkhunter sysbench git curl whois arp-scan rig rcconf sysv-rc-conf python-pip exfat-fuse exfat-utils  lm-sensors autoconf tig cmus wavemon testdisk glances xclip powerline default-jre default-jdk tasksel ffmpeg dtrx ubuntu-restricted-extras && pip install --upgrade pip && pip install speedtest-cli --upgrade && snap install micro --edge --classic`


mps-youtube (official repos) Features https://github.com/mps-youtube/mps-youtube

vtop, npm error????
java-1.8.0-openjdk-devel icedtea-web java-1.8.0-openjdk-headless java-1.8.0-openjdk && java-1.8.0-openjdk-devel icedtea-web java-1.8.0-openjdk-headless java-1.8.0-openjdk ????


When prompted for the Postfix mail system, choose "Local Mail" and indicate a name for the mail system.  
Agree with the "ttf-mscorefonts-installer" licence arreement.  

`apt -y install apt-listchanges`


2. CLAMAV
apt -y install clamav clamav-daemon clamav-freshclam  
cp /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf.bckp;  
echo "SafeBrowsing true" >> /etc/clamav/freshclam.conf;  
/etc/init.d/clamav-daemon restart && /etc/init.d/clamav-freshclam restart  
clamdscan -V  s


setez clamav
Ubuntu/Debian-based
https://www.unixmen.com/installing-scanning-clamav-ubuntu-14-04-linux/

freshclam  
If you get the folowing errors, it means freshclam is already running by the clamav user
ERROR: /var/log/clamav/freshclam.log is locked by another process
ERROR: Problem with internal logger (UpdateLogFile = /var/log/clamav/freshclam.log).

to check the above statement, run the following  
`sudo lsof /var/log/clamav/freshclam.log`

clamscan -r /  

To put all the infected files list on a particular file, please issue the following command in the terminal.
clamscan -r /folder/to/scan/ | grep FOUND >> /path/to/save/report/myfile.txt
clamscan -r / | grep FOUND >> /home/crt/clamscan.txt


OR

The daily scan

The below cronjob will run a virus database definition update (so that the scan always has the most recent definitions) and afterwards run a full scan which will only report when there are infected files on the system. It also does not remove the infected files automatically, you have to do this manually. This way you make sure that it does not delete /bin/bash by accident.

crontab -e
## This should be a root cronjob.
30 01 * * * /usr/bin/freshclam --quiet; /usr/bin/clamscan --recursive --no-summary --infected / 2>/dev/null >> /home/crt/clamscan2.txt

The 2>/dev/null options keeps the /proc and such access denied errors out of the report. The infected files however are still found and reported.

Also make sure that your cron is configured so that it mails you the output of the cronjobs. The manual page will help you with that.

This is how a sample email looks if you have an infection:

/home/remy/eicar.zip: Eicar-Test-Signature FOUND
/home/remy/eicar.com: Eicar-Test-Signature FOUND


Extra: the targeted scan

The below cronjob is an example and you should adapt it. It updates the virus definitions and scans the folder /var/www/sites/uploader.com/public-html/uploads/ two times per hour, and if it found any files it removes them.

## This should be a root cronjob.
*/29 * * * * /usr/bin/freshclam --quiet; /usr/bin/clamscan --recursive --no-summary --infected --remove /var/www/sites/uploader.com/public-html/uploads 2>/dev/null

This is how a sample email might look like:

/var/www/sites/uploader.com/public-html/uploads/eicar.zip: Eicar-Test-Signature FOUND
/var/www/sites/uploader.com/public-html/uploads/eicar.zip: Removed.
/var/www/sites/uploader.com/public-html/uploads/eicar.com: Eicar-Test-Signature FOUND
/var/www/sites/uploader.com/public-html/uploads/eicar.com: Removed.



or a simple crontab


crontab -e
00 00 * * * clamscan -r /location_of_files_or_folder

https://www.howtoforge.com/tutorial/configure-clamav-to-scan-and-notify-virus-and-malware/

s*

5. RKHUNTER
scanez. pun in cron
https://www.digitalocean.com/community/tutorials/how-to-use-rkhunter-to-guard-against-rootkits-on-an-ubuntu-vps
https://www.rosehosting.com/blog/how-to-install-and-use-rkhunter-on-a-linux-server-for-rootkit-local-exploits-malware-and-backdoors-scanning/
https://www.startpage.com/do/dsearch?query=Warning%3A+The+command+%27%2Fusr%2Fbin%2Flwp-request%27+has+been+replaced+by+a+script%3A+%2Fusr%2Fbin%2Flwp-request%3A+a+%2Fusr%2Fbin%2Fperl+-w+script%2C+ASCII+text+executable&cat=web&pl=opensearch&language=english


`rkhunter --versioncheck && rkhunter --update && rkhunter --propupd && rkhunter -c --enable all --disable none --rwo`  

Finally, we are ready to perform our initial run. This will produce some warnings. This is expected behavior, because rkhunter is configured to be generic and Ubuntu diverges from the expected defaults in some places. We will tell rkhunter about these afterwards:

nu fac asta, trec la urmatorul pas
#rkhunter -c --enable all --disable none

nano /var/log/rkhunter.log

Another alternative to checking the log is to have rkhunter rig print out only warnings to the screen, instead of all checks:

acest pas l-am inclus in prima comanda
#rkhunter -c --enable all --disable none --rwo

15 00 * * * /usr/bin/rkhunter --cronjob --update --quiet



6. NTP
Set Date
dpkg-reconfigure tzdata && nano /etc/ntp.conf

Adding time servers
#nano /etc/ntp.conf
pool 0.md.pool.ntp.org iburst
pool 0.ro.pool.ntp.org iburst
pool 0.ua.pool.ntp.org iburst
pool 0.europe.pool.ntp.org iburst
pool 0.pool.ntp.org iburst

Update everything
timedatectl && timedatectl set-ntp true && /etc/init.d/ntp status && timedatectl


7. NEOFETCH
add-apt-repository -y ppa:dawidd0811/neofetch && apt -y update && apt -y install neofetch && nano  ~/.bashrc
adaug la finalul fisierului comanda neofetch
http://www.omgubuntu.co.uk/2016/11/neofetch-terminal-system-info-app



8. SPEEDTEST-CLI
https://www.howtoforge.com/tutorial/check-internet-speed-with-speedtest-cli-on-ubuntu/
usage
speedtest-cli
speedtest-cli --bytes
speedtest-cli --share
speedtest-cli --simple
speedtest-cli --list
speedtest-cli --list | grep –i Australia
speedtest-cli --server [server ID]
speedtest-cli --server 2604
speedtest-cli --version
speedtest-cli --help

CREATING AN INTERNET SPEED LOG WITH SPEEDTEST-CLI
Speedtest-cli can be run as cronjob to get an internet speed test log. Open the crontab with this command:

crontab -e

And add this line (I'll assume that speedtest_cli.py is installed in /usr/local/bin) to the crontab:

# fiecare 15 minute
*/15 * * * *  echo "" >> /home/vanea/speedtest-CLI-log.txt && echo "Data: `date +\%Y-\%m-\%d_\%H:\%M:\%S`" >> /home/vanea/speedtest-CLI-log.txt && /usr/local/bin/speedtest-cli --server 3668 >> /home/vanea/speedtest-CLI-log.txt && echo "" >> /home/vanea/speedtest-CLI-log.txt;

ss*

speedtest-cli --simple --server 3668

# Moldcell
speedtest-cli --csv --csv-delimiter , --server 3668

# Moldtelecom
speedtest-cli --csv --csv-delimiter , --server 3750

# IP HOST Data Center
speedtest-cli --csv --csv-delimiter , --server 9281

# S.E. Special Telecommunications Center
speedtest-cli --csv --csv-delimiter , --server 9737

5686) Sun Communications (Chisinau, Moldova) [112.71 km]
6433) StarNet (Chisinau, Moldova) [112.71 km]
4149) Orange Moldova SA (Chisinau, Moldova) [112.71 km]
4784) Enciu-Moldovan Constantin I.I. (Suceava, Romania) [126.26 km]
11854) Stefan cel Mare University of Suceava (Suceava, Romania) [126.26 km]
5996) Lanet Network (Kamianets-Podilskyi, Ukraine) [142.96 km]
3076) DSS Group (Chernivtsi, Ukraine) [160.00 km]
6291) Intelekt Group (Chernivtsi, Ukraine) [160.00 km]
5766) Alpha Group (Chernivtsi, Ukraine) [160.00 km]
1528) JSC Interdnestrcom (Tiraspol, Republic of Moldova) [163.68 km]


9. SYSBENCH
sysbench --test=cpu --cpu-max-prime=20000 run
sysbench --test=fileio --file-total-size=10G prepare
sysbench --test=fileio --file-total-size=3G prepare
sysbench --test=fileio --file-total-size=3G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
sysbench --test=fileio --file-total-size=3G cleanup


10. UNATTENDED UPGRADES & APT-LISTCHANGES
https://lowendbox.com/blog/how-to-configure-ubuntu-vps-for-automatic-security-updates/
https://www.tecmint.com/auto-install-security-updates-on-debian-and-ubuntu/


For ubuntu and debian
dpkg-reconfigure -plow unattended-upgrades

nano /etc/apt/apt.conf.d/20auto-upgrades:
should already have these lines
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";

add this
APT::Periodic::Verbose "2";

check if line for security updates is uncommented, by default it is
nano /etc/apt/apt.conf.d/50unattended-upgrades

on Ubuntu
        "${distro_id}:${distro_codename}-security";

on Ubuntu/Debian
The following commands will check for updates every day while cleaning out the local download archive each week.
nano /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists “1”;
APT::Periodic::Download-Upgradeable-Packages “1”;
APT::Periodic::AutocleanInterval “7”;
APT::Periodic::Unattended-Upgrade “1”;

The results of unattended-upgrades will be logged to /var/log/unattended-upgrades.


For more tweaks
nano /etc/apt/apt.conf.d/50unattended-upgrades


### For VirtualBox (taken from Fedora 25 KDE)
#### Mount Shared Folder on Fedora Guest OS
After the folder was mounted in VirtualBox interface, it should mounted inside the guest OS as well.

* Mount as root  
`sudo mount -t vboxsf Documents /home/vanea/Documents`

The problem is that only the root will have the rights to work with this folder

* Mount as a simple user  
`sudo mount -t vboxsf -o rw,uid=1000,gid=1000 Documents Documents/`

Now the user with the _ID=1000_ and _group ID=1000_ (the standard users) can work with the mounted folder

#### One-liner
`echo '#!/bin/bash' > /etc/rc.d/rc.local && echo 'mount -t vboxsf -o rw,uid=1000,gid=1000 Documents /home/vanea/Documents' >> /etc/rc.d/rc.local && chmod +x /etc/rc.d/rc.local && reboot`


#### GUI Software
#### GUI Software
To install all the needed GUI application ones should run the following commands

`apt -y install software-properties-common libpng16-16 libqt5core5a libqt5widgets5 libsdl1.2debian libqt5x11extras5 libsdl-ttf2.0-0 python-gtk2 glade python-gtk-vnc python-glade2 python-configobj && add-apt-repository -y ppa:team-xbmc/ppa && add-apt-repository -y ppa:wfg/0ad && add-apt-repository -y ppa:libreoffice/ppa && add-apt-repository -y ppa:otto-kesselgulasch/gimp && add-apt-repository -y ppa:inkscape.dev/stable && add-apt-repository -y ppa:philip5/extra && add-apt-repository -y ppa:pmjdebruijn/darktable-release && add-apt-repository -y 'deb https://deb.opera.com/opera-stable/ stable non-free' && echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add - && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add - && sh -c "echo 'deb http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/rawtherapee.list" && wget -q http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/Release.key -O- | sudo apt-key add - && wget -qO- https://deb.opera.com/archive.key | sudo apt-key add - && apt -y update && apt -y upgrade && apt -y dist-upgrade`




`apt -y install dnscrypt-proxy virtualbox-5.1 kodi 0ad keepassx gimp gimp-gmic gmic gimp-plugin-registry gimp-resynthesizer inkscape krita digikam5 darktable rawtherapee filezilla gramps opera-stable kate amarok k3b ktorrent macchanger macchanger-gtk gnucash homebank kmymoney && sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" && curl -LO https://go.skype.com/skypeforlinux-64.deb && dpkg -i skypeforlinux-64.deb && curl -LO https://atom.io/download/deb && dpkg -i deb && curl -LO http://downloads.sourceforge.net/project/pacmanager/pac-4.0/pac-4.5.5.7-all.deb && dpkg -i pac-4.5.5.7-all.deb && apt -yf install && if [[ $(curl ipinfo.io/ip) ]]; then   wget https://netix.dl.sourceforge.net/project/veracrypt/VeraCrypt%201.20/veracrypt-1.20-setup.tar.bz2 &&   if [[ $(shasum -a 256 veracrypt-1.20-setup.tar.bz2 | grep '6ecef017ba826243d934f46da8c34c516d399e85b0716ed019f681d24af7e236') ]]; then   tar -xvf veracrypt-1.20-setup.tar.bz2; else   rm -rf veracrypt-1.20-setup.tar.bz2 && echo "SHA256SUM-ul arhivei descarcate nu corespunde. Arhiva a fost stearsa!" && echo ; fi; else   echo "Internet nu este!"; fi`


# Netbeans
tmpth=/tmp/inst_session;
mkdir -p $tmpth && cd $_;
nb_lnk=(http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh);
nb_shsm=('0442d4eaae5334f91070438512b2e8abf98fc84f07a9352afbc2c4ad437d306c');
nb=(netbeans-8.2-linux.sh);
# Checking if there is any internet connection by getting ones publi IP
if [[ $(curl $ipinf) ]]; then
    # Getting the actual archive with the Veracrypt installation packages
    curl $nb_lnk > $nb &&
    # Verifying the SHA256SUM of the archive
    if [[ $(shasum -a 256 $nb | grep $nb_shsm) ]]; then
        # Extracting the archive
        chmod +x $nb;
        su -c "./$nb --silent" -s /bin/sh vanea
    else
        rm -rf $nb && echo "The SHA256SUM of the downloaded archive has a different value. The archive was removed!" && echo ;
    fi;
else
    echo "There is no internet connection at the moment! Please try again later.";
fi


Manually agree with Opera's popup about updating the browser together with the system updates/ugrades
Manually agree with the Macchanger popup about automatically changing the mac address.

automatically agree with ncurses or cli popups?????
https://www.tecmint.com/manage-xenserver-with-xencenter-and-xen-orchestra/
alternative dnscrypt-proxy
finante



http://www.ubuntugeek.com/macchanger-utility-for-manipulating-the-mac-address-of-network-interfaces-included-gui-utility.html
https://linuxconfig.org/how-to-change-mac-address-using-macchanger-on-kali-linux




manually

openxemanager
apt -y install python-gtk2 glade python-gtk-vnc python-glade2 python-configobj && git clone https://github.com/OpenXenManager/openxenmanager.git && cd openxenmanager && python setup.py install

to run just type openxenmanager








#### Arc Theme
GTK3
`dnf -y install arc-theme`

KDE
run as simple user, then as root again
`wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/arc-kde/master/install-arc-kde-home.sh | sh`

Papirus Icon Theme  
https://github.com/PapirusDevelopmentTeam/papirus-icon-theme  
`dnf copr enable dirkdavidis/papirus-icon-theme && dnf -y install papirus-icon-theme`

https://www.tecmint.com/pac-manager-a-remote-ssh-session-management-tool/

Programe pentru instalare

a. Foto/Design
	Gimp 2.9 DEV
		sudo add-apt-repository ppa	:otto-kesselgulasch/gimp-edge
		sudo apt-get update
		sudo apt-get install gimp gimp-gmic gmic

### How to install JAVA JRE/JDK
https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get

Gnome Recipes
WPS Office / StarOffice / Microsoft
codeweavers

https://github.com/jnv/lists
https://github.com/sindresorhus/
  https://github.com/sindresorhus/awesome


https://github.com/Kickball/awesome-selfhosted

https://github.com/n1trux?tab=repositories
  https://github.com/n1trux/awesome-sysadmin
  https://github.com/n1trux/awesome-fonts
  https://github.com/n1trux/Awesome
  https://github.com/n1trux/awesome-security


https://github.com/alebcay/awesome-shell
https://github.com/bayandin/awesome-awesomeness
https://github.com/donnemartin/awesome-aws


SELF-HOSTED

IDE / Editors
  + Eclipse Che. În VM
  + Codiad. În LXC
  + Cloud9. În LXC
    pornire temporara
    port forwarding http://unix.stackexchange.com/questions/111433/iptables-redirect-outside-requests-to-127-0-0-1
    iptables -t nat -I PREROUTING -p tcp -d 10.10.10.0/24 --dport 8181 -j DNAT --to-destination 127.0.0.1:8181
    sysctl -w net.ipv4.conf.eth0.route_localnet=1
    nodejs /root/cloud9/server.js -w WordPress
    ori
    nodejs /root/cloud9/server.js -w /home/vanea/Documents/WordPress
  + ICEcoder. În LXC

  #Orion
  #Dirigible


https://www.mailgun.com/


Containers / apps
  + sandstorm
    probleme în LXC. Rulează OK în VM
  https://cloudron.io/
  https://yunohost.org/#/


Latex editors / IDE
    ShareLatex


web-terminal
  gateone html5

web vnc/rdp
guacamole

File collab.
  Gogs / gitea
  + Gitlab
  Phabricator
  JetBrains team and collab software for free
  Atllassian 10$ team and collab software
  gitbucket
  openproject


Collab. for it
  Mattermost

Statistics
  Netdata https://netdata.firehol.org/
  Goaccess CLI and web https://github.com/allinurl/goaccess

Commentaries on the web sites
DISQUS alternative https://posativ.org/isso/ sa instalez pe un server separat

image hosting
  https://chevereto.com/free


Firefox Auth Server
Firefox Content Server
Firefox Sync Server

Newsletter
  Mailchimp alternatives
  phplist
  sendy


irc chat / web chat

Music player and server
  https://github.com/andrewrk/groovebasin
  https://www.sonerezh.bzh/
  https://www.mopidy.com/ + plugins and interfaces
  https://github.com/Libresonic/libresonic
  https://koel.phanan.net/
  http://ampache.org/
  http://www.fomori.org/cherrymusic/
  https://github.com/jakubroztocil/cloudtunes

Genealogy
    geneweb

Mindmaps
  https://github.com/drichard/mindmaps


browser notifications from terminal
https://notica.us/73CeqmdT



  Local repositories for
    Debian: 2 stable versions
            1 unstable
    Ubuntu: 2 latest LTS's
            1 latest version
    CentOS: two latest
            epel + other 2 repos
    Fedora: latest stable repo
    openSuse: latest tumbleweed
              latest leap

Flat-file CMS
Flat-file blog
Flat-file site


Inventory and audit

Security audit
  Nessus

Ansible automation
  Rundeck

Collabtive and alike for project management/tasks/tickets/issues/to do`s / Tasks / Calendar for it and others
  tine20.net
  tikiwiki



Password manager
  https://github.com/nuxsmin/sysPass




  Note-taking app
    #Paperwork
    Laverna
    permanote
    https://www.tagspaces.org/
    TiddlyWiki
        Zim Wiki
        Wiki
        Static Wiki


  Finances/Accounting
    https://www.budgetapp.io/
    https://www.dotledger.com/
    http://www.economizzer.org/
    https://firefly-iii.github.io/


Email
    sogo
    openx mail
    group office
    zimbra
    horde
    roundcube

Recipes

File sharing
  Owncloud
  Nextcloud

Office
  Onlyoffice
  Open365
  webodf


Static web site generator
  https://www.staticgen.com/
  https://staticsitegenerators.net/
  hugo
  ghost
  jekyll



torrent tracker
    rutracker

GPS
  OwnTracks
  http://www.opengts.org/


pastebin services
  http://phpaste.sourceforge.net/


rss / read-it-later
  tiny tiny rss
  Nunux Keeper
  wallabag
  freshrss


database
  phpmyadmin configurat sa lucreze cu alte servere
  sidu http://topnew.net/sidu/sidu-feature.php
  adminer



allinone
  wikisuite

search system
  searx


Stackovverflow alternative
  nodebb
  discourse


docs system
  http://ricostacruz.com/flatdoc/
  https://docs.readthedocs.io/en/latest/install.html



CI / CD
  travis
  jenkins
  https://buddy.works/buddy-go
  codeship
  phing
  ansible
  php+reddis+nginx
  encryptfs
  graylog



https://github.com/sovereign/sovereign

OS's
  https://piratebox.cc/openwrt:diy
  Debian FreedomBox
  Openmediavault
  http://ubos.net/



http://www.omgubuntu.co.uk/2017/03/stacer-ubuntu-system-cleaner-update
https://itsfoss.com/upgrade-linux-kernel-ubuntu/
http://www.tecmint.com/best-linux-log-monitoring-and-management-tools/?utm_content=buffera583d&utm_medium=social&utm_source=facebook.com&utm_campaign=buffer
https://www.fossmint.com/encryptpad-secure-encrypted-text-editor-for-linux/?utm_content=buffera1ca8&utm_medium=social&utm_source=facebook.com&utm_campaign=buffer






# Nu am facut
6. DISABLE SSH TIMEOUT
https://docs.oseems.com/general/application/ssh/disable-timeout
nano /etc/ssh/sshd_config
TCPKeepAlive no
ClientAliveInterval 30
ClientAliveCountMax 100

What it basically means is that the server will not send the TCP alive packet to check if the client's connection is working, yet will still send the encrypted alive message every 30 seconds but will only disconnect after 24 hours of inactivity. Be sure to restart the SSH service after the reconfiguration. The following command would work for most Unix based servers;



icedteawebplugin ????
