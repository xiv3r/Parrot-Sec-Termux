#!/bin/bash
apt-get install udisks2 -y
echo " " > /var/lib/dpkg/info/udisks2.postinst
apt-mark hold udisks2
dpkg-reconfigure tzdata
apt-get install xfce4 xfce4-goodies xfce4-terminal parole tigervnc-standalone-server dbus-x11 -y
apt-get --fix-broken install

#Setup the necessary files
mkdir -p ~/.vnc
echo "
#!/bin/bash
export PULSE_SERVER=127.0.0.1
xrdb $HOME/.Xresources
startxfce4
" > ~/.vnc/xstartup

echo "
#!/bin/sh
export DISPLAY=:1
export PULSE_SERVER=127.0.0.1
rm -rf /run/dbus/dbus.pid
dbus-launch startxfce4
" > /usr/local/bin/vncstart

   echo "vncserver -geometry 1600x900 -name remote-desktop :1" > /usr/local/bin/vnc-start
   echo "vncserver -kill :*" > /usr/local/bin/vnc-stop
   chmod +x ~/.vnc/xstartup
   chmod 700 /usr/local/bin/*
   clear
   
#Browser Fix
wget https://raw.githubusercontent.com/wahasa/Ubuntu/main/Patch/passwd -P .vnc/
apt install firefox-esr -y
vnc-start
sleep 5
DISPLAY=:1 firefox &
sleep 10
pkill -f firefox
vnc-stop
sleep 2

wget -O $(find ~/.mozilla/firefox -name *.default-esr)/user.js https://raw.githubusercontent.com/wahasa/Ubuntu/main/Patch/user.js

rm .vnc/passwd
   
