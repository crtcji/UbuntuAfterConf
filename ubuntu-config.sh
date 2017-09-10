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
# ------------------------------------
# mypath=$PWD;
usr=(vanea);
ipinf=(ipinfo.io/ip);
bckp=(bckp);
dns_provider=(dnscrypt.eu-nl);
hstnm=(ion.catlab.bl);

# FUNCTIONS

# Updates/upgrades the system
up () {
  upvar="update upgrade dist-upgrade";
  for upup in $upvar; do
    echo -e "Executing \e[1m\e[34m$upup\e[0m";
    apt-get -y $upup > /dev/null;
  done
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

# Echoes that a specific application ($@) is being backed up
inst_echo () {
  echo -e "Installing \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that a specific application ($@) is being purged with the reason
rm_echo () {
  echo && echo -e "Removing \e[1m\e[34m$1\e[0m package because \e[1m\e[31m$2\e[0m ...";
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

# ------------------------------------------
# END VARIABLES SECTION



# BEGIN CONFIGURATION SECTION
# ----------------------------------

# Disabling the Ubuntu Network Manager
nmcli networking off;

# Checking if there is NO internet connection by getting ones public IP
#if [[ ! $(curl -s ipinfo.io/ip) ]]; then
wget -q --tries=10 --timeout=20 --spider http://google.com
if [[ ! $? -eq 0 ]]; then

  # The main statement
  srclst=(/etc/apt/sources.list);

  # Cheking the existence of the $srclist configurartion file
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
        ufw status verbose; # for analyze only

        # Opening outgoing ports using UFW. Redirecting UFW output to /dev/null device
        ufw_ports="80/tcp 443/tcp 443/udp 53/tcp 123/udp 43/tcp 22/tcp 8000:8054/tcp";

        for a in $ufw_ports; do
          ufw allow out $a > /dev/null;
          echo -e "Opening outgoing port: \e[1m\e[34m$a\e[0m ...";
        done

        ufw reload;

        # Checks if the firewall is running
        if ufw status verbose | grep -qw "active"; then


          # Enabling the Ubuntu Network Manager
          nmcli networking on;

          ufw disable && wget -q --tries=10 --timeout=20 --spider http://google.com && ufw enable;
          # && ufw reload;
        	#/etc/init.d/ufw stop;
        	#/etc/init.d/ufw start;
        	#sleep 60;
    # Waiting several seconds for the changes to be applied
          #sleep 10;

          # Checking if there is any internet connection by getting ones public IP
          #if [[ $(curl -s ipinfo.io/ip) ]]; then
          wget -q --tries=10 --timeout=20 --spider http://google.com;
          if [[ $? -eq 0 ]]; then

            # Updating repository lists
            echo "Updating repository lists ...";
            apt-get -y update > /dev/null;

            # Installing dnscrypt-proxy
            inst_echo dnscrypt-proxy;
            apt-get -y install dnscrypt-proxy > /dev/null;

            # Configuring DNSCrypt-Proxy
            echo "Configuring DNSCrypt-Proxy";
            dnscr_cfg=(/etc/default/dnscrypt-proxy);

            # Checking if DNSCrypt-Proxy is running
            if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > /dev/null; then

              # Checking if the /etc/default/dnscrypt-proxy exists
              if [ -f $dnscr_cfg ]; then

                bckup $dnscr_cfg;

                # Replacing the default DNS provider in the /etc/default/dnscrypt-proxy configuration file to the $dns_provider
                sed -i -e "/DNSCRYPT_PROXY_RESOLVER_NAME=/c\DNSCRYPT_PROXY_RESOLVER_NAME=$dns_provider" $dnscr_cfg;
                service dnscrypt-proxy restart;

                # Checking if DNSCrypt-Proxy is ON and running the chosen DNS Provider
                if ! /etc/init.d/dnscrypt-proxy status -l | grep -w "Stopped DNSCrypt proxy." > /dev/null && /etc/init.d/dnscrypt-proxy status -l | grep  -w "resolver-name=$dns_provider" > /dev/null; then

                  # Updating repository lists as well as updating/upgrading the system
                  up;

                  # Installing applications

                  # Adding external repositories

                  apprepo=("ppa:team-xbmc/ppa" "ppa:wfg/0ad" "ppa:libreoffice/ppa" "ppa:otto-kesselgulasch/gimp" "ppa:inkscape.dev/stable" "ppa:philip5/extra" "ppa:pmjdebruijn/darktable-release" "deb https://deb.opera.com/opera-stable/ stable non-free" "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" "deb http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/ /");

                  for b in "${apprepo[@]}"; do
                    addrepo_echo "${b[@]}";
                    add-apt-repository -y "${b[@]}" > /dev/null 2>&1;
                  done


                  # Adding external repositories keys

                  apprepokey=("https://deb.opera.com/archive.key" "https://www.virtualbox.org/download/oracle_vbox_2016.asc" "https://www.virtualbox.org/download/oracle_vbox.asc" "http://download.opensuse.org/repositories/home:/rawtherapee/xUbuntu_16.04/Release.key");

                  for c in "${apprepokey[@]}"; do
                    addrepokey_echo "${c[@]}";
                    wget -qO- "${c[@]}" | sudo apt-key add - > /dev/null 2>&1;
                  done

                  up;

                  # Libraries for the CLI/GUI Applications
                  applib="software-properties-common libpng16-16 libqt5core5a libqt5widgets5 libsdl1.2debian libqt5x11extras5 libsdl-ttf2.0-0 python-gtk2 glade python-gtk-vnc python-glade2 python-configobj libgtk2-appindicator-perl libc6:i386";

                  # CLI  Applications
                  appcli="screen mc htop iptraf ntp ntpdate tmux unattended-upgrades sysbench git curl whois arp-scan rig rcconf sysv-rc-conf python-pip exfat-fuse exfat-utils lm-sensors autoconf tig cmus wavemon testdisk glances xclip powerline default-jre default-jdk tasksel ffmpeg dtrx apt-listchanges clamav clamav-daemon clamav-freshclam debconf-utils p7zip redshift fail2ban";

                  # GUI Applications
                  appgui="virtualbox-5.1 kodi 0ad keepassx gimp gimp-gmic gmic gimp-plugin-registry inkscape krita digikam5 darktable rawtherapee filezilla gramps kate amarok k3b ktorrent gnucash homebank kmymoney audacity gnome-sushi vlc handbrake bleachbit soundconverter easytag sound-juicer gwenview nautilus-actions yakuake terminator aptoncd gresolver gitg git-cola uget gpodder virt-viewer clamtk redshift-gtk mysql-workbench gpick workrave rsibreak"

                  # The main multi-loop for installing apps/libs
                  for d in $applib $appcli $appgui; do
                    inst_echo $d;
                    apt-get -y install $d > /dev/null;
                  done

                  up;

                  # Separate installation subsection (1st)

                  # The installation of the following applications requires user interaction. It is installed separately in order to separate the installation lines and automation lines from the installation loop of the standard utilites that do not require user interaction at the instllation step.

                  # Here is a list of options that need to be autoanswered once during the installation process of the apps listed in the second variable ($debsel2)
                  debsel=(
                    "opera-stable opera-stable/add-deb-source select false"
                    "macchanger/automatically_run select true"
                    "wireshark-common/install-setuid select true"
                    "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true"
                  )

                  # The applications that shows pop-ups during the their installation
                  debsel2=(
                    "opera-stable"
                    "macchanger"
                    "wireshark"
                    "ubuntu-restricted-extras"
                  )

                  # The loop
                  for e in ${!debsel[*]}; do
                    inst_echo "${debsel2[$e]}";
                    "${debsel[$e]}" | debconf-set-selections && quietinst "${debsel2[$e]}";
                  done

                  # Installing RKHunter
                  inst_echo RKHunter;
                  debconf-set-selections <<< "postfix postfix/mailname string "$hstnm"" && debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local Only'" && quietinst rkhunter;
                  # apt-get -y install rkhunter > /dev/null;

                  up;

                  # END: Separate installation subsection (1st)

                  # Separate installation subsection (2nd)

                  # The loop
                  tmpth=/tmp/inst_session;
                  mkdir -p $tmpth && cd $tmpth;

                  # The list of direct links to the downloaded apps
                  app=(
                    "https://go.skype.com/skypeforlinux-64.deb"
                    "https://atom.io/download/deb"
                    "http://downloads.sourceforge.net/project/pacmanager/pac-4.0/pac-4.5.5.7-all.deb"
                    "https://dbeaver.jkiss.org/files/4.2.0/dbeaver-ce_4.2.0_amd64.deb"
                    );

                  # The list of 256 shasums of the eralier downloaded apps
                  app2=(
                    "1f31c0e9379f680f2ae2b4db3789e936627459fe0677306895a7fa096c7db2c5"
                    "0b8074f1cf75e733691b94c845991479c331dd541440886038b9cdfc8df5f313"
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
                  if [[ $(curl $ipinf) ]]; then

                    for f in ${!app[*]}; do

                      # Checking if the required link is valid
                      if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then

                        # Getting the actual installation package
                        curl -L "${app[$f]}" > "${app3[$f]}";

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
                  if [[ $(curl $ipinf) ]]; then

                    for f in ${!app[*]}; do

                      # Checking if the required link is valid
                      if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then

                        # Getting the actual installation package
                        curl -L "${app[$f]}" > "${app3[$f]}";

                        # Verifying the SHA256SUM of the package
                        if [[ $(shasum -a 256 "${app3[$f]}" | grep "${app2[$f]}") ]]; then

                          # Unarchiving the application into $applctn
                          inst_echo "${app3[$f]}";
                          tar -xf $tmpth/${app3[$f]} -C $applctn;

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
                  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

                  # Netbeans
                  nb_lnk=(http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh);
                  nb_shsm=('0442d4eaae5334f91070438512b2e8abf98fc84f07a9352afbc2c4ad437d306c');
                  nb=(netbeans-8.2-linux.sh);

                  # Checking if there is any internet connection by getting ones public IP
                  if [[ $(curl $ipinf) ]]; then

                    # Checking if the required link is valid
                    if curl -L --output /dev/null --silent --fail -r 0-0 $nb_lnk; then

                      # Getting the actual installation package
                      curl -L $nb_lnk > $nb;

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
                  pip install --upgrade pip;

                  # Installing Speedest-CLI
                  inst_echo Speedtest;
                  pip install speedtest-cli --upgrade;

                  # Installing Micro Editor
                  #inst_echo Micro Editor;
                  #snap install micro --edge --classic;

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
                  "cups cups-server-common"
                  "remmina remmina-common remmina-plugin-rdp remmina-plugin-vnc"
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
                  "tool, which gives possibilities to start installation by clicking on url, can be executed with js, which is not secure"
                  "remote login for LightDm"
                  "remote login rdp for LightDm"
                  "remote login uccsconfigure for LightDm"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "Zeitgeist Basic Telemetry"
                  "if you don't use printers"
                  "if you don't use remmina remote connection tool. has libraries for remote connection, which can be unsecure"
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
                    apt-get -y purge "${telepack[$f]}"  > /dev/null;
                  done


                  # Fail2Ban installation (protects from brute force login):

                  # END: Fail2Ban



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
                  clamscan -r / | grep FOUND >> $rprtfldr/clamscan_first_scan.txt;

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
                  echo -e '#!/bin/bash\n\n/usr/bin/freshclam --quiet;\n/usr/bin/clamscan --recursive --exclude-dir=/media/ --no-summary --infected / 2>/dev/null >> '$rprtfldr'/clamscan_daily_$(date +"%m-%d-%Y").txt;' >> /etc/cron.daily/clamscan.sh && chmod 755 /etc/cron.daily/clamscan.sh;

                  # END: ClamAV section: configuration and the first scan


                  # RKHunter configuration section

                  # The first thing we should do is ensure that our rkhunter version is up-to-date.
                  rkhunter --versioncheck > /dev/null 2>&1;

                  # Verifying if the previous command run successfully (exit status 0) then it goes to the next step
                  RESULT=$?
                  if [ $RESULT -eq 0 ]; then
                    upd_echo rkhunter;
                    # Updating our data files.
                    rkhunter --update > /dev/null 2>&1;

                    RESULT2=$?
                    if [ $RESULT2 -eq 0 ]; then
                      upd_echo rkhunter signatures;
                      # With our database files refreshed, we can set our baseline file properties so that rkhunter can alert us if any of the essential configuration files it tracks are altered. We need to tell rkhunter to check the current values and store them as known-good values:
                      rkhunter --propupd > /dev/null 2>&1;

                      RESULT3=$?
                      if [ $RESULT3 -eq 0 ]; then
                        echo -e "\e[1m\e[34mRKHunter\e[0m scanning the OS ...";
                        # Finally, we are ready to perform our initial run. This will produce some warnings. This is expected behavior, because rkhunter is configured to be generic and Ubuntu diverges from the expected defaults in some places. We will tell rkhunter about these afterwards:
                        # rkhunter -c --enable all --disable none

                        # Note: This will be executed only if the previous one was executed
                        # Another alternative to checking the log is to have rkhunter print out only warnings to the screen, instead of all checks:
                        rkhunter -c --enable all --disable none --rwo > /dev/null 2>&1;

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

                  # END: RKHunter configuration section


                  # Startup Applications (GUI)

                  # The list of the shortcuts names
                  appshrt=(
                    "firefox.desktop"
                    "veracrypt.desktop"
                    "atom.desktop"
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
                  );

                  # The loop
                  echo -e "Setting Startup GUI Applications: ";
                  for f in ${!appshrt[*]}; do
                    echo -e "\e[32m"${appshrt[$f]}"\e[0m";
                    echo "${appshrt2[$f]}" > /home/$usr/.config/autostart/"${appshrt[$f]}";
                  done

                  # END: Startup Applications (GUI)




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
