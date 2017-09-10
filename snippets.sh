snippets
Functions
----------------------------------------------

# Updates/upgrades the system
up () {
  upvar="update upgrade dist-upgrade";
  for upup in $upvar; do
    apt-get -y $upup > /dev/null;
    echo -e "\e[1m\e[31m$upup\e[0m";
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

# Echoes that a specific application ($@) is being backed up
cfg_echo () {
  echo -e "Configuring \e[1m\e[34m$@\e[0m application ...";
}

# Echoes that a specific application ($@) is being purged with the reason
rm_echo () {
  echo && echo -e "Removing \e[1m\e[34m$1\e[0m package because \e[1m\e[32m$2\e[0m ...";
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
  echo -e "\e[1m\e[31mThere is no internet connection at the moment! Please try again later.\e[0m";
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



# Loops
-----------------------------------------------

# General

IF
# The statement searches for a file and does the rest
if [ -f $tmpth/$atm ]; then
  echo "File does NOT exist";
else
  echo "File exists";
fi


# Verifies if the previous command run successfully (exit status 0) then it does the next thing

# Version 1
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo success
else
  echo failed
fi

# Version 2
RESULT=$?
if [ $RESULT == 0 ]; then
  echo success 2
else
  echo failed 2
fi

# Checking if there is any internet connection by getting ones public IP
if [[ $(curl -s ipinfo.io/ip) ]]; then
  # code
else
netconof_echo;
std_echo;
fi


# Checking if there is NO internet connection by getting ones public IP
if [[ ! $(curl -s ipinfo.io/ip) ]]; then
  echo -e "\e[31mThere is no\e[0m \e[1m\e[31minternet connection\e[0m";
else
  netcon_echo;
  std_echo;
fi


# Checking if the required link is valid
if curl -L --output /dev/null --silent --fail -r 0-0 "${app[$f]}"; then
  xx;
else
  yy;
fi



FOR
# looping the values from a initially declared variable
ufw_ports="80/tcp 443/tcp 53/udp 123/udp 43/tcp 22/tcp";
for a in $ufw_ports; do
  ufw allow out $a > /dev/null;
  echo "Opening outgoing port: $a ...";
done




# Specific


# Downloading an app
if [[ $(shasum -a 256 veracrypt-1.20-setup.tar.bz2 | grep '6ecef017ba826243d934f46da8c34c516d399e85b0716ed019f681d24af7e236') ]]; then
  tar -xvf veracrypt-1.20-setup.tar.bz2;
else
  rm -rf veracrypt-1.20-setup.tar.bz2 && echo "SHA256SUM-ul arhivei descarcate nu corespunde. Arhiva a fost stearsa!" && echo ; fi;
