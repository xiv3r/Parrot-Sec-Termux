#!/data/data/com.termux/files/usr/bin/bash

### install dependencies 
pkg install root-repo x11-repo axel bsdtar proot xz-utils neofetch pulseaudio -y

###
neofetch --ascii_distro Parrot -L

### Download Tarball
axel -a --search -o parrot-arm64.tar.xz https://github.com/EXALAB/Anlinux-Resources/raw/refs/heads/master/Rootfs/Parrot/arm64/parrot-rootfs-arm64.tar.xz

### Decompressed tarball
echo "Decompressing Rootfs...!!!"
proot --link2symlink bsdtar -xpJf parrot-arm64.tar.xz --exclude='dev'

### Make directory binds
mkdir -p parrot-arm64/binds
echo "localhost" > parrot-arm64/etc/hostname
echo "127.0.0.1 localhost" > parrot-arm64/etc/hosts
echo "nameserver 8.8.8.8" > parrot-arm64/etc/resolv.conf

### Make executable bin
cat >$PREFIX/bin/parrot << EOF
#!/data/data/com.termux/files/usr/bin/bash -e

pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
    
unset LD_PRELOAD

cmdline="proot \
        --link2symlink \
        -0 \
        -r parrot-arm64 \
        -b /dev \
        -b /proc \
        -b /sdcard \
        -b parrot-arm64/root:/dev/shm \
        -w /root \
           /usr/bin/env -i \
           HOME=/root \
           PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \
           TERM=$TERM \
           LANG=C.UTF-8 \
           /bin/bash --login"

cmd="$@"
if [ "$#" == "0" ];then
    exec $cmdline
else
    $cmdline -c "$cmd"
fi
EOF

### Fix shebang
termux-fix-shebang $PREFIX/bin/parrot
chmod 700 $PREFIX/bin/parrot
parrot
