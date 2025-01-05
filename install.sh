#!/data/data/com.termux/files/usr/bin/bash

### install dependencies 
apt install root-repo x11-repo axel bsdtar proot xz-utils neofetch pulseaudio -y

### Termux vnc
echo "vncserver -geometry 1600x900 -listen tcp :1 && DISPLAY=:1 xhost +" > $PREFIX/bin/vncstart
chmod 700 $PREFIX/bin/vncstart

### Fix audio & Auto launch
cat >>$PREFIX/etc/bash.bashrc << EOF
vncstart &
parrot
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
EOF

### Ascii
neofetch --ascii_distro Parrot -L

### Download Tarball
axel -a --search -o parrot-arm64.tar.xz https://github.com/xiv3r/Parrot-Sec-Termux/releases/download/arm64/parrot-arm64.tar.xz

### Decompressed tarball
echo "Decompressing Rootfs...!!!"
proot --link2symlink bsdtar -xpJf parrot-arm64.tar.xz 2>/dev/null

### Make executable bin
wget -O $PREFIX/bin/parrot https://raw.githubusercontent.com/xiv3r/Parrot-Sec-Termux/refs/heads/main/parrot/parrot

### Fix shebang
termux-fix-shebang $PREFIX/bin/parrot
chmod 700 $PREFIX/bin/parrot
parrot
