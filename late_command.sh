#!/bin/bash

# passwordless sudo
echo "%sudo   ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# public ssh key for vagrant user
mkdir /home/vagrant/.ssh
wget -O /home/vagrant/.ssh/authorized_keys "https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"
chmod 755 /home/vagrant/.ssh
chmod 644 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# speed up ssh
echo "UseDNS no" >> /etc/ssh/sshd_config

echo "# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi

# User specific environment and startup programs

HOST=i686-nptl-linux-gnu
export HOST

TOOLCHAIN_PATH=/data/x-tools/i686-nptl-linux-gnu
export TOOLCHAIN_PATH

#ROOTFS_PATH=/usr/local/ToolChain/rootfs
#export ROOTFS_PATH

OPT_PATH=/opt
export OPT_PATH

#OPTEXTERN_PATH=${ROOTFS_PATH}/opt_extern
#export OPTEXTERN_PATH

PATH=$PATH:$HOME/bin:${TOOLCHAIN_PATH}/bin:${TOOLCHAIN_PATH}/i686-nptl-linux-gnu/bin
export PATH


# for x86 ---> i686-nptl-linux-gnu
# for x64 ---> x86_64-unknown-linux-gnu

# just replace with right name" >> /root/.bash_profile

curl http://www.positiv-it.fr/thecus/download/CT/crosstool-ntpl-x86-gcc4.5.3+x64-gcc4.7.2-on-debianx64.tgz > /crosstool-ntpl-x86-gcc4.5.3+x64-gcc4.7.2-on-debianx64.tgz;

cd / && tar zxvf /crosstool-ntpl-x86-gcc4.5.3+x64-gcc4.7.2-on-debianx64.tgz
rm /crosstool-ntpl-x86-gcc4.5.3+x64-gcc4.7.2-on-debianx64.tgz

# display login promt after boot
sed "s/quiet splash//" /etc/default/grub > /tmp/grub
sed "s/GRUB_TIMEOUT=[0-9]/GRUB_TIMEOUT=0/" /tmp/grub > /etc/default/grub
update-grub

# clean up
apt-get clean

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
