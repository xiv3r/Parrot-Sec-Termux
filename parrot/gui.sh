#!/bin/bash

apt install xfce4 xfce4-goodies xfce4-terminal parole tigervnc-standalone-server dbus-x11 tigervnc xorg-xhost -y

### Parrot vnc
echo "
#!/bin/sh
export DISPLAY=:1
export PULSE_SERVER=127.0.0.1
startxfce4
" > /bin/vncstart
chmod 700 /bin/vncstart
echo "vncstart >> .bashrc
