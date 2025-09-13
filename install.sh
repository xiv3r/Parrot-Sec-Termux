#!/data/data/com.termux/files/usr/bin/bash

### install dependencies 
apt install axel bsdtar proot neofetch -y

### Ascii
neofetch --ascii_distro Parrot

### Start-up
sed -i '/parrot/d' $PREFIX/etc/bash.bashrc
echo "parrot" >> $PREFIX/etc/bash.bashrc

# Uninstall
cat > $PREFIX/bin/uninstall-parrot << EOF
#!/data/data/com.termux/files/usr/bin/bash

sed -i '/parrot/d' $PREFIX/etc/bash.bashrc
rm -rf parrot-arm64
rm -f $PREFIX/bin/parrot
EOF
chmod +x $PREFIX/bin/uninstall-parrot

### Download Tarball
axel -o parrot-arm64.tar.xz https://github.com/xiv3r/Parrot-Sec-Termux/releases/download/arm64/parrot-arm64.tar.xz

### Decompressed tarball
echo "Decompressing Rootfs Please Wait...!!!"
proot --link2symlink bsdtar -xpJf parrot-arm64.tar.xz 2>/dev/null

### Make executable bin
wget -qO $PREFIX/bin/parrot https://raw.githubusercontent.com/xiv3r/Parrot-Sec-Termux/refs/heads/main/parrot/parrot
chmod +x $PREFIX/bin/parrot

# fix .bashrc terminal
wget -qO parrot-arm64/root/.bashrc https://raw.githubusercontent.com/xiv3r/Parrot-Sec-Termux/refs/heads/main/parrot/root.bashrc
