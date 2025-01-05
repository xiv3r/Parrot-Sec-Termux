#!/data/data/com.termux/files/usr/bin/bash

### install dependencies 
pkg install root-repo x11-repo axel bsdtar proot xz-utils neofetch pulseaudio -y
### Download Tarball
axel -a --search -o parrot-arm64.tar.xz https://github.com/EXALAB/Anlinux-Resources/raw/refs/heads/master/Rootfs/Parrot/arm64/parrot-rootfs-arm64.tar.xz
### Decompress tarball
mkdit -p parrot-arm64
echo "Decompressing Rootfs...!!!"
proot --link2symlink bsdtar -xpJf parrot-arm64.tar.xz -C parrot-arm64  --exclude='dev' ||:
###
mkdir -p parrot-arm64/binds
echo "localhost" > parrot-arm64/etc/hostname
echo "127.0.0.1 localhost" > parrot-arm64/etc/hosts
echo "nameserver 8.8.8.8" > parrot-arm64/etc/resolv.conf
### pull config 
wget -O .parrot https://raw.githubusercontent.com/xiv3r/Parrot-Sec-Termux/refs/heads/main/parrot/parrot
### Fix shebang
termux-fix-shebang .parrot
chmod +x .parrot
### make executable
echo "bash .parrot" >$PREFIX/bin/parrot
chmod 700 $PREFIX/bin/parrot
