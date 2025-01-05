#!/bin/bash

apt install xfce4 xfce4-goodies xfce4-terminal parole tigervnc-standalone-server dbus-x11 tigervnc xorg-xhost -y

### Parrot vnc
cat >/usr/bin/vncstart << EOF
#!/bin/bash
export DISPLAY=:1
export PULSE_SERVER=127.0.0.1
startxfce4
EOF
chmod 700 /usr/bin/vncstart
echo "vncstart >> .bashrc
