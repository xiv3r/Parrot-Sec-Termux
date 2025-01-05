#!/data/data/com.termux/files/usr/bin/bash

pkg install root-repo x11-repo axel bsdtar proot xz-utils neofetch pulseaudio -y

axel -a --search -o parrot-arm64.tar.xz https://github.com/EXALAB/Anlinux-Resources/raw/refs/heads/master/Rootfs/Parrot/arm64/parrot-rootfs-arm64.tar.xz

echo "Decompressing Rootfs, please be patient."
proot --link2symlink bsdtar -xpJf parrot-arm64.tar.xz

wget -O .parrot https://raw.githubusercontent.com/xiv3r/Parrot-Sec-Termux/refs/heads/main/parrot/parrot
echo "Fixing shebang"
termux-fix-shebang .parrot
chmod +x .parrot
