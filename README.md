# UbuntuAfterConf
Set of bash scripts to automate the configuration of the freshly installed Ubuntu 16.04 LTS

#### Work in progress for the next version can be foun [here](https://github.com/crtcji/UbuntuAfterConf/projects/1).

## Installation of the Ubuntu 16.04 LTS

> - Install Ubuntu without internet connection  
>- Whenever possible check the mdsums of the manually downloaded apps.

### Installation process  
_This section should be automated._  

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

## After installation
### Configuration
###### At this point there will be still no internet connection
Wait for the Ubuntu asking to save the passphrase for the encrypted home directory. When the window will popup just press "Run this action now" and enter you user's password in the automatically opened terminal. Then save somewhere the passphrase. It's needed when restoring access to the home folder.  

##### Disable Telemetry
- System Settings -> Security and Privacy -> Diagnostics

##### Run the main script
Before running the script Enable the internet connection.

##### ESET _(optional)_
Manually install Eset Antivirus for Linux.  
_libc6:i386_ library is needed for the ESET AV to start installation pocess. It is  automatically installed on the previous step.
  * Verify shasum
  * Install manually as root user
  * I am showing only the modified steps.
  * Custom
  * Let "Enable ThreatSense.Net Early Warning System" checked. * Press "Setup" button and disable the "Submission of Suspicious Files" as well as the "Submission of Anonymous Statistical Information".  
  * Enable detection of ptoentially unwanted applications.  
  * Restart the system as the installation software sugests.  


#### Ubuntu Settings Center
_This section should be automated._  

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


### Unity-tweak-tool
##### Unity
  * Launcher
    * Minimize single windows applications on click
  * Webapps
      * preauthorised domains: untickle amazon and ubuntuone

#### Windows manager
  * Workspace switcher
    * horizontal 4
    * vertical 1
  * Window snapping
  * Hot corners
  * Additional
