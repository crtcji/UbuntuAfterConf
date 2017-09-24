#!/bin/bash

# Copyright Profor Ion, contact@iprofor.it
# 2017-08-26

# Inspirations sources

# Telemetry https://github.com/butteff/Ubuntu-Telemetry-Free-Privacy-Secure
# ClamAV
# RKHunter https://www.digitalocean.com/community/tutorials/how-to-use-rkhunter-to-guard-against-rootkits-on-an-ubuntu-vps


# Run as root

# Clear all previous bash variables
# exec bash;


# VARIABLES SECTION
# -----------------------------------
# mypath=$PWD;
usr=(vanea);
ipinf=(ipinfo.io/ip);
bckp=(bckp);
dns_provider=(dnscrypt.eu-nl);
hstnm=(bear.hostname.local);
dn=/dev/null 2>&1
dn1=(/dev/null);

# FUNCTIONS

# Updates/upgrades the system
up () {
  upvar="update upgrade dist-upgrade";
  for upup in $upvar; do
    echo -e "Executing \e[1m\e[34m$upup\e[0m";
    #apt-get -yqq -o=Dpkg::Use-Pty=0 $upup > $dn;
    apt-get -yqq $upup > /dev/null 2>&1;
  done
  blnk_echo;
}


# Echoes that there is no X file
nofile_echo () {
  echo -e "\e[31mThere is no file named:\e[0m \e[1m\e[31m$@\e[0m";
}

# Echoes a standard message
std_echo () {
  echo -e "\e[32mPlease check it manually.\e[0m";
  echo -e "\e[1m\e[31mThe script stops here.\e[0m";
}

# Echoes that the internet connection was not switched off
netconon_echo () {
  echo -e "\e[31mThe internet connection was not switched \e[1m\e[31mOFF\e[0m \e[31mon previous step.\e[0m";
}

# Echoes that the internet connection was not switched off
netconof_echo () {
  echo -e "\e[31mThe internet connection was not switched \e[1m\e[31mON\e[0m \e[31mon previous step.\e[0m";
}

# Echoes that the given application is not running
notrun () {
  echo -e "\e[1m\e[31m$@\e[0m \e[31mis not running.\e[0m";
}

# Echoes that a specific application ($@) is being installed
inst_echo () {
  echo -e "Installing \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that a specific application ($@) is being downloaded
dwnl_echo () {
  echo -e "Downloading \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that a specific application ($@) is being backed up
cfg_echo () {
  echo -e "Configuring \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that a specific application ($@) is being purged with the reason
rm_echo () {
  echo -e "Removing \e[1m\e[34m$1\e[0m package because \e[1m\e[32m$2\e[0m ...";
}

# Echoes that a specific repository ($@) is being added
addrepo_echo () {
  echo -e "Importing \e[1m\e[34m$@\e[0m repository ...";
}

# Echoes that a specific repository key ($@) is being added
addrepokey_echo () {
  echo -e "Importing \e[1m\e[34m$@\e[0m repository key ...";
}

# Echoes activation of a specific application option ($@)
enbl_echo () {
  echo -e "Activating \e[1m\e[34m$@\e[0m ...";
}

# Echoes that a specific application ($@) is being updated
upd_echo () {
  echo -e "Updating \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that updatng of a specific application ($@) failed
updfld_echo () {
  echo -e "Updating \e[1m\e[34m$@\e[0m application \e[1m\e[31mFAILED\e[0m.";
}

# Echoes there is no internet
nonet_echo () {
  echo -e "\e[1m\e[31mThere is no internet connection at the moment! Please try again later.\e[0m ...";
}

# Echoes the checked SHA256SUM do not corespond to the one had in local list
shaserr_echo () {
  echo -e "\e[1m\e[31mThe SHA256SUM of the downloaded package $@ has a different value. The archive was removed\e[0m";
}

# Echoes the link is invalid
nolnk_echo () {
  echo -e "The requested link \e[1m\e[31m$@\e[0m does not exist or it's name was changed meanwhile. Please try again later.";
}

# Backing up a given ($@) file/directory
bckup () {
  echo -e "Backing up: \e[1m\e[34m$@\e[0m ...";
  cp -r $@ $@_$(date +"%m-%d-%Y")."$bckp";
}

# Quiet installation
  quietinst () {
  DEBIAN_FRONTEND=noninteractive apt-get -yf install -qq $@ < /dev/null > /dev/null;
}

chg_unat10 () {
  # The following options will have unattended-upgrades check for updates every day while cleaning out the local download archive each week.
  echo "
    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";" > $unat10;
}

blnk_echo () {
  echo ""
}
# ------------------------------------------
# END VARIABLES SECTION



# BEGIN CONFIGURATION SECTION
# ----------------------------------

# Disabling the Ubuntu Network Manager
echo -e "Switching \e[1m\e[31mOFF\e[0m the network connection ...";
nmcli networking off;

# Checking if there is NO internet connection
#if [[ ! $(curl -s ipinfo.io/ip) ]]; then
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ ! $? -eq 0 ]]; then

  # The main statement
  srclst=(/etc/apt/sources.list);

  # Cheking the existence of the $srclist configuration file
  if [ -f $srclst ]; then

    # Backing up the "/etc/apt/sources.list" file
    bckup $srclst;

    # Enabling the Multiverse, Universe and Partner repositories as well as switching to the main (UK) repository servers.
    echo -e "Adding \e[1m\e[34mMultiverse\e[0m, \e[1m\e[34mUniverse\e[0m and \e[1m\e[34mPartner\e[0m repositories as well as switching to the main \e[1m\e[34m(UK)\e[0m repository server ... ";
    echo "
    deb http://archive.ubuntu.com/ubuntu xenial main restricted
    deb http://archive.ubuntu.com/ubuntu xenial-updates main restricted

    deb http://archive.ubuntu.com/ubuntu xenial universe
    deb http://archive.ubuntu.com/ubuntu xenial-updates universe

    deb http://archive.ubuntu.com/ubuntu xenial multiverse
    deb http://archive.ubuntu.com/ubuntu xenial-updates multiverse

    deb http://archive.ubuntu.com/ubuntu xenial-backports main restricted universe multiverse

    deb http://archive.canonical.com/ubuntu xenial partner

    deb http://archive.ubuntu.com/ubuntu xenial-security main restricted
    deb http://archive.ubuntu.com/ubuntu xenial-security universe
    deb http://archive.ubuntu.com/ubuntu xenial-security multiverse" > $srclst;

      # UFW
      ufwc=(/etc/ufw/ufw.conf);

      # Checking for the /etc/ufw/ufw.conf file
      if [ -f $ufwc ]; then

        # Backing up the file
        bckup $ufwc;

        # Disabling IPV6 in UFW
        echo "IPV6=no" >> /etc/ufw/ufw.conf;
        echo -e "Disabling \e[1m\e[34mIPV6\e[0m in \e[1m\e[34mUFW\e[0m ...";

        # Applying UFW policies
        ufw default deny outgoing && ufw default deny incoming && ufw enable;
        # ufw status verbose; # for analyze only

        # Opening outgoing ports using UFW. Redirecting UFW output to /dev/null device
        # 80/tcp - for Web
        # 443/tcp - for secure Web (https) TCP
        # 443/udp - for secure Web (https) UDP
        # 53/tcp - for DNS TCP
        # 53/udp - for DNS UDP
        # 123/udp - for NTP
        # 43/tcp - for whois app to work properly
        # 22/tcp - for general SSH connections
        # 7539/tcp - for IJC VPS's SSH
        # 22170/tcp - for IJC Office's SSH
        # 2083/tcp - for cPanel SSL TCP
        # 2096/tcp - for cPanel Webmail SSL TCP

        # 51413/tcp - for Transmission
        # 8000:8054/tcp - for audio feed of the Romanian Radio Broadcasting Society
        # 8078/tcp - for eTeatru audio feed of the Romanian Radio Broadcasting Society
        # 9128/tcp - for MagicFM and RockFM from Romania



        ufw_ports="80/tcp 443/tcp 443/udp 53/tcp 53/udp 123/udp 43/tcp 22/tcp 7539/tcp 22170/tcp 2083/tcp 2096/tcp 51413/tcp 8000:8054/tcp 8078/tcp 9128/tcp";

        for a in $ufw_ports; do
          ufw allow out $a > $dn1;
          echo -e "Opening outgoing port: \e[1m\e[34m$a\e[0m ...";
        done

        ufw reload;

        # Checks if the firewall is running
        if ufw status verbose | grep -qw "active"; then


          # Enabling the Ubuntu Network Manager
          echo -e "Switching \e[1m\e[32mON\e[0m the network connection ...";
          nmcli networking on;

          # For some reason after enabling the firewall there is no way to make outgoing connections. The workaround is to disable the firewall, make an outgoing connection and the reenable it.
          ufw disable && wget -q --tries=10 --timeout=20 --spider http://google.com && ufw enable;
          # && ufw reload;
        	#/etc/init.d/ufw stop;
        	#/etc/init.d/ufw start;
        	#sleep 60;
          # Waiting several seconds for the changes to be applied
          #sleep 10;

          # Checking if there is any internet connection
          #if [[ $(curl -s ipinfo.io/ip) ]]; then
          wget -q --tries=10 --timeout=20 --spider http://google.com;
          if [[ $? -eq 0 ]]; then

            # Updating repository lists
            echo "Updating repository lists ...";
            apt-get -yqq update > $dn;

            # Installing dnscrypt-proxy
            inst_echo dnscrypt-proxy;
            apt-get -yqq install dnscrypt-proxy > $dn1;

            # Configuring DNSCrypt-Proxy
            dnscr_cfg=(/etc/default/dnscrypt-proxy);

            # Checking if DNSCrypt-Proxy is running
            if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > $dn1;
             then

              # Checking if the /etc/default/dnscrypt-proxy exists
              if [ -f $dnscr_cfg ]; then

                bckup $dnscr_cfg;
                cfg_echo dnscrypt-proxy;

                # Replacing the default DNS provider in the /etc/default/dnscrypt-proxy configuration file to the $dns_provider
                sed -i -e "/DNSCRYPT_PROXY_RESOLVER_NAME=/c\DNSCRYPT_PROXY_RESOLVER_NAME=$dns_provider" $dnscr_cfg;
                service dnscrypt-proxy restart;

                # Checking if DNSCrypt-Proxy is ON and running the chosen DNS Provider
                if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > $dn1 && /etc/init.d/dnscrypt-proxy status -l | grep  -w "resolver-name=$dns_provider" > $dn1;

                # if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." && /etc/init.d/dnscrypt-proxy status -l | grep  -w "resolver-name=$dns_provider";
                then

                  # Updating repository lists as well as updating/upgrading the system
                  blnk_echo;
                  up;

                  # Installing applications

                  # Adding external repositories

                  apprepo=("ppa:team-xbmc/ppa" "ppa:wfg/0ad" "ppa:libreoffice/ppa" "ppa:otto-kesselgulasch/gimp" "ppa:inkscape.dev/stable" "ppa:philip5/extra" "ppa:pmjdebruijn/darktable-release" "deb https://deb.opera.com/opera-stable/ stable non-free" "deb http://download.virtualbox.org/virtualbox/debian xenial contrib");
                  # "deb http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/ /"

                  for b in "${apprepo[@]}"; do
                    addrepo_echo "${b[@]}";
                    add-apt-repository -y "${b[@]}" > /dev/null 2>&1;
                  done

                  blnk_echo;


                  # Adding external repositories keys

                  apprepokey=("https://deb.opera.com/archive.key" "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "https://www.virtualbox.org/download/oracle_vbox.asc");
                  # "http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/Release.key"

                  for c in "${apprepokey[@]}"; do
                    addrepokey_echo "${c[@]}";
                    wget -qO- "${c[@]}" | sudo apt-key add - > $dn;
                  done

                  blnk_echo;
                  up;

                  # Libraries for the CLI/GUI Applications
                  # libc6:i386 - for ESET Antivirus for Linux
                  # (python2.7 - this package is already installed) python-gtk2 glade python-gtk-vnc python-glade2 python-configobj: for openxenmanager
                  # transcode - for K3B to rip DVDs
                  applib="software-properties-common libpng16-16 libqt5core5a libqt5widgets5 libsdl1.2debian libqt5x11extras5 libsdl-ttf2.0-0 python-gtk2 glade python-gtk-vnc python-glade2 python-configobj libgtk2-appindicator-perl libc6:i386 gedit-plugins transcode folder-color rhythmbox-plugin-alternative-toolbar";

                  # CLI Applications
                  appcli="screen mc htop iptraf ntp ntpdate tmux unattended-upgrades sysbench git curl whois arp-scan rig rcconf sysv-rc-conf python-pip exfat-fuse exfat-utils lm-sensors autoconf tig cmus wavemon testdisk glances xclip powerline default-jre default-jdk tasksel ffmpeg dtrx apt-listchanges clamav clamav-daemon clamav-freshclam debconf-utils p7zip redshift fail2ban shellcheck";

                  # GUI Applications
                  appgui="virtualbox-5.1 kodi keepassx gimp gimp-gmic gmic gimp-plugin-registry inkscape krita digikam5 darktable rawtherapee filezilla gramps kate amarok k3b ktorrent gnucash homebank kmymoney audacity gnome-sushi vlc handbrake bleachbit soundconverter easytag sound-juicer gwenview nautilus-actions yakuake terminator aptoncd gresolver uget gpodder virt-viewer clamtk redshift-gtk mysql-workbench gpick workrave brasero unity-tweak-tool indicator-multiload shutter openttd gnome-control-center gnome-online-accounts"

                  # The main multi-loop for installing apps/libs
                  for d in $applib $appcli $appgui; do
                    inst_echo $d;
                    #apt-get -yqq install $d > $dn;
                    apt-get -yqq install $d > /dev/null 2>&1;
                  done

                  blnk_echo;
                  up;

                  # Separate installation subsection (1st)

                  # The installation of the following applications requires user interaction. It is installed separately in order to separate the installation lines and automation lines from the installation loop of the standard utilites that do not require user interaction at the instllation step.

                  # Here is a list of options that need to be autoanswered once during the installation process of the apps listed in the second variable ($debsel2)

                  debsel=(
                    "opera-stable opera-stable/add-deb-source select false"
                    "macchanger macchanger/automatically_run select true"
                    "wireshark-common wireshark-common/install-setuid select true"
                    "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true"
                  );

                  # The applications that shows pop-ups during the their installation
                  debsel2=(
                    "opera-stable"
                    "macchanger"
                    "wireshark"
                    "ubuntu-restricted-extras"
                  );

                  # The loop
                  for e in ${!debsel[*]}; do
                    inst_echo "${debsel2[$e]}";
                    echo "${debsel[$e]}" | debconf-set-selections && quietinst "${debsel2[$e]}";
                  done


                  blnk_echo;

                  # Installing RKHunter
                  inst_echo RKHunter;
                  debconf-set-selections <<< "postfix postfix/mailname string "$hstnm"" && debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local Only'" && quietinst rkhunter;
                  apt-get -yqq install rkhunter > $dn1;

                  blnk_echo;
                  up;

                  # END: Separate installation subsection (1st)

                  # Separate installation subsection (2nd)

                  # The loop
                  tmpth=/tmp/inst_session;
                  mkdir -p $tmpth && cd $tmpth;

                  # The list of direct links to the downloaded apps
                  app=(
                    "http://media-azi.md/skypeforlinux-64.deb"
                    "http://media-azi.md/atom.deb"
                    "http://downloads.sourceforge.net/project/pacmanager/pac-4.0/pac-4.5.5.7-all.deb"
                    "https://dbeaver.jkiss.org/files/4.2.0/dbeaver-ce_4.2.0_amd64.deb"
                    );

                  # The list of 256 shasums of the eralier downloaded apps
                  app2=(
                    "1f31c0e9379f680f2ae2b4db3789e936627459fe0677306895a7fa096c7db2c5"
                    "870a763c3033db8b812f3367e2de7bb383ba2d791b6ab9af70e31e7ad33ddbac"
                    "82e73c8631fe055a79dc4352956ed22df05cbae1886ceaeb22b2bf562b0eb9ca"
                    "6abfd028162f3cb0044aebf191cdf2887414c83d5fd008565024c44fee074c4e"
                    );

                  # The list of names of the downloaded apps
                  app3=(
                    "skype.deb"
                    "atom.deb"
                    "pac.deb"
                    "dbeaver.deb"
                    );

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl --silent $ipinf) ]]; then

                    for f in ${!app[*]}; do

                      # Checking if the required link is valid
                      if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then

                        # Getting the actual installation package
                        curl -L --silent "${app[$f]}" > "${app3[$f]}";

                        # Verifying the SHA256SUM of the package
                        if [[ $(shasum -a 256 "${app3[$f]}" | grep "${app2[$f]}") ]]; then

                          # Installing the application with necesary dependencies (-yf parameter)
                          inst_echo "${app3[$f]}";
                          quietinst $tmpth/"${app3[$f]}";

                        else
                          rm -rf $tmpth/"${app3[$f]}";
                          shaserr_echo "${app3[$f]}";
                        fi;

                      else
                          nolnk_echo "${app[$f]}";
                      fi;

                    done

                    blnk_echo;

                  else
                      nonet_echo;
                      std_echo;
                  fi

                  up;

                  # END: Separate installation subsection (2nd)



                  # Separate installation subsection (3rd)

                  # The loop
                  applctn=/usr/bin;
                  #tmpth=/tmp/inst_session;
                  #mkdir -p $tmpth && cd $tmpth;

                  # The list of direct links to the downloaded apps
                  app=(
                    "https://github.com/cjimd/moldovaazi/raw/gh-pages/vcrypt.tar"
                    "https://download.jetbrains.com/python/pycharm-edu-4.0.tar.gz"
                    );

                  # The list of 256 shasums of the eralier downloaded apps
                  app2=(
                    "c645aa8b2669688cdbceb643e5b437e3435a7dead59355420a481de79df399e9"
                    "ff057e9ad76e58f7441698aec3d0200d7808a9a113e0db7030f432d5289ee30b"
                    );

                  # The list of names of the downloaded ppps
                  app3=(
                    "vcrypt.tar"
                    "pycharm.tar.gz"
                    );

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl --silent $ipinf) ]]; then

                    for f in ${!app[*]}; do

                      # Checking if the required link is valid
                      if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then

                        # Getting the actual installation package
                         dwnl_echo "${app3[$f]}";
                         curl -L --silent "${app[$f]}" > "${app3[$f]}";

                        # Verifying the SHA256SUM of the package
                        if [[ $(shasum -a 256 "${app3[$f]}" | grep "${app2[$f]}") ]]; then

                          # Unarchiving the application into $applctn
                          inst_echo "${app3[$f]}";
                          tar -xf $tmpth/"${app3[$f]}" -C $applctn;

                        else
                          rm -rf $tmpth/"${app3[$f]}";
                          shaserr_echo "${app3[$f]}";
                        fi;

                      else
                          nolnk_echo "${app[$f]}";
                      fi;

                    done

                  else
                      nonet_echo;
                      std_echo;
                  fi

                  # END: Separate installation subsection (3nd)


                  # Separate installation subsection (4th)

                  # Calibre
                  inst_echo Calibre;
                  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()" > $dn;

                  # Netbeans
                  nb_lnk=(http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh);
                  nb_shsm=('0442d4eaae5334f91070438512b2e8abf98fc84f07a9352afbc2c4ad437d306c');
                  nb=(netbeans-8.2-linux.sh);

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl --silent $ipinf) ]]; then

                    # Checking if the required link is valid
                    if curl -L --output /dev/null --silent --fail -r 0-0 $nb_lnk; then

                      # Getting the actual installation package
                      curl -L --silent $nb_lnk > $nb;

                      # Verifying the SHA256SUM of the archive
                      if [[ $(shasum -a 256 $nb | grep $nb_shsm) ]]; then

                          # Installing the package
                          inst_echo $nb;
                          # Setting executable rights
                          chmod +x $nb;
                          # Installing
                          su -c "./$nb --silent" -s /bin/sh $usr

                      else
                          rm -rf $tmpth/"${app3[$f]}";
                          shaserr_echo "${app3[$f]}";
                      fi;

                    else
                        nolnk_echo "${app[$f]}";
                    fi;

                  else
                      nonet_echo;
                      std_echo;
                  fi


                  # Updating Python PIP
                  echo -e "Updating \e[1m\e[34mpip\e[0m ...";
                  pip install --upgrade pip > $dn;

                  # Installing Speedest-CLI
                  inst_echo Speedtest;
                  pip install speedtest-cli --upgrade > $dn;

                  # Installing Micro Editor
                  #inst_echo Micro Editor;
                  #snap install micro --edge --classic;

                  blnk_echo;
                  up;

                  # END: Separate installation subsection (4th)

                  # END: Installing CLI utilities


                  # Telemetry
                  # Removing packages that send statisrics and usage data to Canonical and third-parties

                  # Guest session disable
                  sudo sh -c 'printf "[SeatDefaults]\nallow-guest=false\ngreeter-show-remote-login=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'

                  telepack=(
                  "unity-lens-shopping"
                  "unity-webapps-common"
                  "apturl"
                  "remote-login-service"
                  "lightdm-remote-session-freerdp"
                  "lightdm-remote-session-uccsconfigure"
                  "zeitgeist"
                  "zeitgeist-datahub"
                  "zeitgeist-core"
                  "zeitgeist-extension-fts"
                  "cups"
                  "cups-server-common"
                  "remmina"
                  "remmina-common"
                  "remmina-plugin-rdp"
                  "remmina-plugin-vnc"
                  "unity8*"
                  "gdbserver"
                  "gvfs-fuse"
                  "evolution-data-server"
                  "evolution-data-server-online-accounts"
                  "snapd"
                  "libhttp-daemon-perl"
                  "vino"
                  "unity-scope-video-remote"
                  )

                  # Comments to each purged telepack
                  telepack2=(
                  "Unity Amazon"
                  "Unity web apps"
                  "gives possibilities to start installation by clicking on url, can be executed with js, which is not secure"
                  "remote login for LightDm"
                  "remote login rdp for LightDm"
                  "remote login uccsconfigure for LightDm"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "if you don't use printers"
                  "if you don't use printers"
                  "has libraries for remote connection, which can be unsecure"
                  "has libraries for remote connection, which can be unsecure"
                  "has libraries for remote connection, which can be unsecure"
                  "has libraries for remote connection, which can be unsecure"
                  "just remove it, because of potential telemetry from unity8, which is in beta state and exists only for preview, for now you can use 7 version. potential problem"
                  "remote tool for gnome debug"
                  "virtual file system.potential problem"
                  "I just don't like server word here. Potentional connection possibility? potential problem"
                  "potential problem"
                  "telemetric package manager from canonical"
                  "http server for perl"
                  "vnc server (remote desktop share tool)"
                  "potential problem"
                  )

                  # The loop
                  for f in ${!telepack[*]}; do
                    rm_echo "${telepack[$f]}" "${telepack2[$f]}" ;
                    apt-get -yqq purge "${telepack[$f]}"  > $dn1;
                  done

                  blnk_echo;


                  # END: Telemetry section


                  # ClamAV section: configuration and the first scan

                  clmcnf=(/etc/clamav/freshclam.conf);
                  rprtfldr=(/home/$usr/ClamAV-Reports);

                  bckup $clmcnf;
                  mkdir -p $rprtfldr;

                  # Enabling "SafeBrowsing true" mode
                  enbl_echo SafeBrowsing;
                  echo "SafeBrowsing true" >> $clmcnf;

                  # Restarting CLAMAV Daemons
                  /etc/init.d/clamav-daemon restart && /etc/init.d/clamav-freshclam restart
                  # clamdscan -V s

                  # Scanning the whole system and palcing all the infected files list on a particular file
                  # echo "ClamAV is scanning the OS ...";
                  # clamscan -r / | grep FOUND >> $rprtfldr/clamscan_first_scan.txt > $dn;

                  # Crontab: The daily scan

                  # The below cronjob will run a virus database definition update (so that the scan always has the most recent definitions) and afterwards run a full scan which will only report when there are infected files on the system. It also does not remove the infected files automatically, you have to do this manually. This way you make sure that it does not delete /bin/bash by accident.
                  #
                  # The 2>/dev/null options keeps the /proc and such access denied errors out of the report. The infected files however are still found and reported.
                  #
                  # Also make sure that your cron is configured so that it mails you the output of the cronjobs. The manual page will help you with that.

                  # One way: if the computer is off in the time frame when it is supposed to be scanned by the daemon, it will NOT be scanned next time the computer is on.
                                    #crontab -l | { cat; echo "
                  # ## ClamAV Daily scan
                  # 30 01 * * * /usr/bin/freshclam --quiet; /usr/bin/clamscan --recursive --no-summary --infected / 2>/dev/null >> $rprtfldr/clamscan_daily.txt"; } | crontab -

                  # This way, Anacron ensures that if the computer is off during the time interval when it is supposed to be scanned by the daemon, it will be scanned next time it is turned on, no matter today or another day.
                  echo -e "Creating a \e[1m\e[34mcronjob\e[0m for the ClamAV ...";
                  echo -e '#!/bin/bash\n\n/usr/bin/freshclam --quiet;\n/usr/bin/clamscan --recursive --exclude-dir=/media/ --no-summary --infected / 2>/dev/null >> '$rprtfldr'/clamscan_daily_$(date +"%m-%d-%Y").txt;' >> /etc/cron.daily/clamscan.sh && chmod 755 /etc/cron.daily/clamscan.sh;

                  blnk_echo;

                  # END: ClamAV section: configuration and the first scan


                  # RKHunter configuration section

                  # The first thing we should do is ensure that our rkhunter version is up-to-date.
                  rkhunter --versioncheck > $dn;

                  # Verifying if the previous command run successfully (exit status 0) then it goes to the next step
                  RESULT=$?
                  if [ $RESULT -eq 0 ]; then
                    upd_echo rkhunter;
                    # Updating our data files.
                    # // FIXME: The following two commands are a temporary workaround because for the first time of running it gives eq=1, so there is a need to tun it for the second time in order to get eq=0 so that the rest of the statements are executed.
                    rkhunter --update > $dn;
                    rkhunter --update > $dn;

                    RESULT2=$?
                    if [ $RESULT2 -eq 0 ]; then
                      upd_echo rkhunter signatures;
                      # With our database files refreshed, we can set our baseline file properties so that rkhunter can alert us if any of the essential configuration files it tracks are altered. We need to tell rkhunter to check the current values and store them as known-good values:
                      rkhunter --propupd > $dn;

                      RESULT3=$?
                      if [ $RESULT3 -eq 0 ]; then
                        echo -e "\e[1m\e[34mRKHunter\e[0m scanning the OS ...";
                        # Finally, we are ready to perform our initial run. This will produce some warnings. This is expected behavior, because rkhunter is configured to be generic and Ubuntu diverges from the expected defaults in some places. We will tell rkhunter about these afterwards:
                        # rkhunter -c --enable all --disable none

                        # Note: This will be executed only if the previous one was executed
                        # Another alternative to checking the log is to have rkhunter print out only warnings to the screen, instead of all checks:
                        rkhunter -c --enable all --disable none --rwo > $dn;

                      else
                        echo "\e[1m\e[34mRKHunter\e[0m scanning the OS \e[1m\e[31mFAILED\e[0m.";
                        std_echo;
                      fi


                    else
                      updfld_echo rkhunter signatures;
                      std_echo;
                    fi

                  else
                    updfld_echo rkhunter;
                    std_echo;
                  fi


                  # for viewing the logs
                  # cat /var/log/rkhunter.log | grep -w "Warning:"

                  # Crontab (Anacron): The daily scan
                  # The previous 3 if statements are useless, because the line bellow do all the same
                  # The --cronjob option tells rkhunter to not output in a colored format and to not require interactive key presses. The update option ensures that our definitions are up-to-date. The quiet option suppresses all output.
                  echo -e '#!/bin/bash\n\n/usr/bin/rkhunter --cronjob --update --quiet;' >> /etc/cron.daily/rkhunter_scan.sh && chmod 755 /etc/cron.daily/rkhunter_scan.sh;

                  blnk_echo;

                  # END: RKHunter configuration section


                  # Unattended-Upgrades configuration section

                  unat20=(/etc/apt/apt.conf.d/20auto-upgrades);
                  unat50=(/etc/apt/apt.conf.d/50unattended-upgrades);
                  unat10=(/etc/apt/apt.conf.d/10periodic);

                  # Cheking the existence of the $unat20, $unat50, $unat10 configuration files
                  if [[ -f $unat20 ]] && [[ -f $unat50 ]] && [[ -f $unat10 ]]; then

                    for k in $unat20 $unat50 $unat10; do
                      bckup $k && mv $k*."$bckp" /root;
                    done


                    # Inserting the right values into it
                    echo "
                      APT::Periodic::Update-Package-Lists "1";
                      APT::Periodic::Unattended-Upgrade "1";
                      APT::Periodic::Verbose "2";" > $unat20;


                        # Checking if line for security updates is uncommented, by default it is
                        if [[ $(cat $unat50 | grep -wx '[[:space:]]"${distro_id}:${distro_codename}-security";') ]]; then

                          chg_unat10;
                        else
                          echo "
                  // Automatically upgrade packages from these (origin:archive) pairs
                  Unattended-Upgrade::Allowed-Origins {
                  	"${distro_id}:${distro_codename}";
                  	"${distro_id}:${distro_codename}-security";
                  	// Extended Security Maintenance; doesn't necessarily exist for
                  	// every release and this system may not have it installed, but if
                  	// available, the policy for updates is such that unattended-upgrades
                  	// should also install from here by default.
                  	"${distro_id}ESM:${distro_codename}";
                  //	"${distro_id}:${distro_codename}-updates";
                  //	"${distro_id}:${distro_codename}-proposed";
                  //	"${distro_id}:${distro_codename}-backports";
                  };

                  // List of packages to not update (regexp are supported)
                  Unattended-Upgrade::Package-Blacklist {
                  //	"vim";
                  //	"libc6";
                  //	"libc6-dev";
                  //	"libc6-i686";
                  };

                  // This option allows you to control if on a unclean dpkg exit
                  // unattended-upgrades will automatically run
                  //   dpkg --force-confold --configure -a
                  // The default is true, to ensure updates keep getting installed
                  //Unattended-Upgrade::AutoFixInterruptedDpkg "false";

                  // Split the upgrade into the smallest possible chunks so that
                  // they can be interrupted with SIGUSR1. This makes the upgrade
                  // a bit slower but it has the benefit that shutdown while a upgrade
                  // is running is possible (with a small delay)
                  //Unattended-Upgrade::MinimalSteps "true";

                  // Install all unattended-upgrades when the machine is shuting down
                  // instead of doing it in the background while the machine is running
                  // This will (obviously) make shutdown slower
                  //Unattended-Upgrade::InstallOnShutdown "true";

                  // Send email to this address for problems or packages upgrades
                  // If empty or unset then no email is sent, make sure that you
                  // have a working mail setup on your system. A package that provides
                  // 'mailx' must be installed. E.g. "user@example.com"
                  //Unattended-Upgrade::Mail "root";

                  // Set this value to "true" to get emails only on errors. Default
                  // is to always send a mail if Unattended-Upgrade::Mail is set
                  //Unattended-Upgrade::MailOnlyOnError "true";

                  // Do automatic removal of new unused dependencies after the upgrade
                  // (equivalent to apt-get autoremove)
                  //Unattended-Upgrade::Remove-Unused-Dependencies "false";

                  // Automatically reboot *WITHOUT CONFIRMATION*
                  //  if the file /var/run/reboot-required is found after the upgrade
                  //Unattended-Upgrade::Automatic-Reboot "false";

                  // If automatic reboot is enabled and needed, reboot at the specific
                  // time instead of immediately
                  //  Default: "now"
                  //Unattended-Upgrade::Automatic-Reboot-Time "02:00";

                  // Use apt bandwidth limit feature, this example limits the download
                  // speed to 70kb/sec
                  //Acquire::http::Dl-Limit "70";" > $unat50;

                          chg_unat10;
                        fi

                        # The results of unattended-upgrades will be logged to /var/log/unattended-upgrades.
                        # For more tweaks nano /etc/apt/apt.conf.d/50unattended-upgrades

                  blnk_echo;

                  else
                    nofile_echo $unat20 or $unat50 or $unat10;
                    std_echo;
                  fi

                  # END: Unattended-Upgrades configuration section


                  # Startup Applications (GUI)

                  # The list of the shortcuts names
                  appshrt=(
                    "firefox.desktop"
                    "veracrypt.desktop"
                    "atom.desktop"
                    "redshift-gtk.desktop"
                    "rhythmbox.desktop"
                    "virtualbox.desktop"
                  );

                  # The list of the shortcuts names content
                  appshrt2=(
                    "[Desktop Entry]
                    Type=Application
                    Exec=firefox
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Mozilla Firefox
                    Name=Mozilla Firefox
                    Comment[en_US]=Autostarting Firefox with the OS
                    Comment=Autostarting Firefox with the OS"

                    "[Desktop Entry]
                    Type=Application
                    Exec=veracrypt
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=VeraCrypt
                    Name=VeraCrypt
                    Comment[en_US]=Autostarting VeraCrypt with the OS
                    Comment=Autostarting VeraCrypt with the OS"

                    "[Desktop Entry]
                    Type=Application
                    Exec=atom
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Atom Editor
                    Name=Atom Editor
                    Comment[en_US]=Autostarting at OS boot
                    Comment=Autostarting at OS boot"

                    "[Desktop Entry]
                    StartupNotify=true
                    Categories=Utility;
                    GenericName=Color temperature adjustment
                    X-GNOME-Autostart-enabled=true
                    Version=1.0
                    Terminal=false
                    Comment=Color temperature adjustment tool
                    Name=Redshift
                    Exec=redshift-gtk
                    Icon=redshift
                    Hidden=false
                    Type=Application"

                    "[Desktop Entry]
                    Type=Application
                    Exec=rhythmbox-client --play-uri=http://89.238.227.6:8004/
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=Rhythmbox
                    Name=Rhythmbox
                    Comment[en_US]=Rhythmbox
                    Comment=Rhythmbox"

                    "[Desktop Entry]
                    Type=Application
                    Exec=virtualbox
                    Hidden=false
                    NoDisplay=false
                    X-GNOME-Autostart-enabled=true
                    Name[en_US]=VirtualBox
                    Name=VirtualBox
                    Comment[en_US]=VirtualBox
                    Comment=VirtualBox"
                  );

                  # There is no autostart directory, so we are going to make it
                  mkdir /home/$usr/.config/autostart;

                  # The loop
                  echo -e "Setting Startup GUI Applications: ";
                  for f in ${!appshrt[*]}; do
                    echo -e "\e[1m\e[32m"${appshrt[$f]}"\e[0m";
                    echo "${appshrt2[$f]}" > /home/$usr/.config/autostart/"${appshrt[$f]}";
                  done

                  blnk_echo;

                  # END: Startup Applications (GUI)

                  echo "Autoremoving unused packages ...";
                  apt-get -yqq autoremove > $dn;
                  blnk_echo;

                  echo "Deleting temporary directory created at the beginning of this script ...";
                  cd / && rm -rf $tmpth;
                  blnk_echo;




                else
                  notrun DNSCrypt-Proxy;
                  echo -e "Maybe the chosen DNS Provider \e[1m\e[31m$dns_provider\e[0m was not saved successfully.\e[0m"
                  std_echo;
                fi

              else
                nofile_echo $dnscr_cfg;
                std_echo;
              fi

            else
              notrun DNSCrypt-Proxy;
              std_echo;
            fi



          else
          netconof_echo;
          std_echo;
          fi

        else
          notrun ufw;
          std_echo;
        fi

      else
        nofile_echo $ufwc;
        std_echo;
      fi


  else
  nofile_echo $srclst;
  std_echo;
  fi


else
  netconon_echo;
  std_echo;
fi
# END CONFIGURATION SECTION
# ----------------------------------
