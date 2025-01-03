
#!/data/data/com.termux/files/usr/bin/bash

pkg install root-repo x11-repo proot xz-utils neofetch pulseaudio -y
echo ""
parrot=2024
build=rolling
neofetch --ascii_distro Parrot -L
case `dpkg --print-architecture` in
      aarch64)
              device="arm64" ;;
      arm*)
              device="armhf" ;;
      i386)
              device="i386" ;;
      x86_64)
              device="amd64" ;;
      *)
              echo "Unknown Architecture."; exit 1 ;;
esac
folder=parrot-$device
if [ -d "$folder" ]; then
        first=1
        echo "Skipping Downloading."
fi
tarball="parrot-rootfs.tar.xz"
if [ "$first" != 1 ];then
        if [ ! -f $tarball ]; then
                echo "Download Rootfs, this may take a while base on your internet speed."
                case `dpkg --print-architecture` in
                aarch64)
                        archurl="arm64" ;;
                arm*)
                        archurl="armhf" ;;
                i386)
                        archurl="i386" ;;
                x86_64)
                        archurl="amd64" ;;
                *)
                        echo "Unknown Architecture."; exit 1 ;;
                esac
                wget -q --show-progress "https://github.com/EXALAB/Anlinux-Resources/raw/refs/heads/master/Rootfs/Parrot/${archurl}/parrot-rootfs-${archurl}.tar.xz" -O $tarball
         fi
         mkdir -p $folder
         echo "Decompressing Rootfs, please be patient."
         proot --link2symlink tar -xpf ~/${tarball} -C ~/$folder/ --exclude='dev' ||:
         
    fi
    mkdir -p $folder/binds
    echo "localhost" > $folder/etc/hostname
    echo "127.0.0.1 localhost" > $folder/etc/hosts
    echo "nameserver 8.8.8.8" > $folder/etc/resolv.conf
bin=.parrot
linux=parrot
echo ""
echo "Writing launch script"
cat > $bin <<- EOM
#!/data/data/com.termux/files/usr/bin/bash

cd \$(dirname \$0)

## Start pulseaudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

## Unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
command="proot"
command+=" --kill-on-exit"
command+=" --link2symlink"
command+=" -0"
command+=" -r $folder"
if [ -n "\$(ls -A $folder/binds)" ]; then
   for f in $folder/binds/* ;do
       . \$f
   done
fi
command+=" -b /dev"
command+=" -b /dev/null:/proc/sys/kernel/cap_last_cap"
command+=" -b /dev/null:/proc/stat"
command+=" -b /dev/urandom:/dev/random"
command+=" -b /proc"
command+=" -b /proc/self/fd:/dev/fd"
command+=" -b /proc/self/fd/0:/dev/stdin"
command+=" -b /proc/self/fd/1:/dev/stdout"
command+=" -b /proc/self/fd/2:/dev/stderr"
command+=" -b /sys"
command+=" -b /data/data/com.termux/files/usr/tmp:/tmp"
command+=" -b $folder/root:/dev/shm"
command+=" -b /data/data/com.termux/files/home:/root"
command+=" -b /sdcard"
command+=" -b /mnt"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games"
command+=" TERM=\$TERM"
command+=" LC_ALL=C"
command+=" LANG=en_US.UTF-8"
command+=" LANGUAGE=en_US"
command+=" /bin/bash --login"
com="\$@"
if [ -z "\$1" ];then
   exec \$command
else
   \$command -c "\$com"
fi
EOM
     echo ""
     echo "Fixing shebang of $linux"
     termux-fix-shebang $bin
     echo "Making $linux executable"
     chmod +x $bin
     echo "Fixing permissions for $linux"
    
echo ""
echo "#Parrot Repositories
deb https://deb.parrot.sh/direct/parrot lory main contrib non-free non-free-firmware
deb https://deb.parrot.sh/direct/parrot lory-updates main contrib non-free non-free-firmware
deb https://deb.parrot.sh/direct/parrot lory-security main contrib non-free non-free-firmware
deb https://deb.parrot.sh/direct/parrot lory-backports main contrib non-free non-free-firmware" > $folder/etc/apt/sources.list.d/parrot.list
rm -rf $folder/etc/apt/sources.list ; touch $folder/etc/apt/sources.list
echo "" > $folder/root/.hushlogin
echo "TZ='Asia/Jakarta'; export TZ" >> $folder/root/.profile
echo "export PULSE_SERVER=127.0.0.1" >> $folder/etc/skel/.bashrc
echo 'bash .parrot' > $PREFIX/bin/$linux
chmod +x $PREFIX/bin/$linux
     clear
     echo ""
     echo "Updating Package,.."
     echo ""
echo "#!/bin/bash
apt update && apt upgrade -y
apt install apt-utils dialog nano sudo tzdata -y
cp .bashrc .bashrc.bak ; cp /etc/skel/.bashrc .
apt upgrade passwd -y
rm -rf ~/.bash_profile
exit" > $folder/root/.bash_profile
bash $bin
     clear
