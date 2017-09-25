# UbuntuAfterConf
Set of bash scripts to automate the configuration of the freshly install Ubuntu 16.04 LTS


## Installation of the Ubuntu 16.04 LTS

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

#### Settings   
##### Desktop   
  * Look  
    * Choose time-changing-wallpapers  
    * Launcher size icon: 40
  * Behavior  
    * Auto-hide the launcher
    * Enable workspaces

##### Brightness & Lock
  * 3 minutes  
  * Lock: ON  
    * 10 minutes
    * Require password

##### Security and privacy
  * Security
    * Waking from suspend  
    * Returning from blank screen  
    * 10 minutes
  * Search  
    * OFF  
  * Diagnostics  
    * Uncheck both options   

##### Text entry
  * Romanian (standard)  
  * Russian  

##### Bluetooth
  * OFF  

##### Keyboard
  * Shortcuts
    * Custom shortcuts  
      * Volume +  
        `amixer -D pulse sset Master 3%+`  
      * Volume -  
        `amixer -D pulse sset Master 3%-`    
      * Suspend _(Shift+AltS)_  
        `systemctl suspend`  

##### Time and Date  
  * Clock
    * 24-hour time  
    * Seconds   
s



1. Disable Telemetry
- System Settings -> Security and Privacy -> Diagnostics
https://github.com/butteff/Ubuntu-Telemetry-Free-Privacy-Secure

2. ESET
_libc6:i386_ library is needed for the ESET AV to start installation pocess.  
`apt -y update && apt -y install libc6:i386`  

  * Verify shasum
  * Install manually as root user
  * I am showing only the modified steps.
  * Custom
  * Let "Enable ThreatSense.Net Early Warning System" checked. * Press "Setup" button and disable the "Submission of Suspicious Files" as well as the "Submission of Anonymous Statistical Information".  
  * Enable detection of ptoentially unwanted applications.  
  * Restart the system as the installation software sugests.  

3. NEOFETCH  
`add-apt-repository -y ppa:dawidd0811/neofetch && apt -y update && apt -y install neofetch && nano  ~/.bashrc`  
adaug la finalul fisierului comanda neofetch  
http://www.omgubuntu.co.uk/2016/11/neofetch-terminal-system-info-app

4. SPEEDTEST-CLI  
https://www.howtoforge.com/tutorial/check-internet-speed-with-speedtest-cli-on-ubuntu/  
usage  
  `speedtest-cli`  
  `speedtest-cli --bytes`  
  `speedtest-cli --share`  
  `speedtest-cli --simple`  
  `speedtest-cli --list`  
  `speedtest-cli --list | grep –i Australia`  
  `speedtest-cli --server [server ID]`  
  `speedtest-cli --server 2604`  
  `speedtest-cli --version`  
  `speedtest-cli --help`  

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

5. SYSBENCH
sysbench --test=cpu --cpu-max-prime=20000 run
sysbench --test=fileio --file-total-size=10G prepare
sysbench --test=fileio --file-total-size=3G prepare
sysbench --test=fileio --file-total-size=3G --file-test-mode=rndrw --init-rng=on --max-time=300 --max-requests=0 run
sysbench --test=fileio --file-total-size=3G cleanup



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



mps-youtube (official repos) Features https://github.com/mps-youtube/mps-youtube

vtop, npm error????
java-1.8.0-openjdk-devel icedtea-web java-1.8.0-openjdk-headless java-1.8.0-openjdk && java-1.8.0-openjdk-devel icedtea-web java-1.8.0-openjdk-headless java-1.8.0-openjdk ????
