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

# Install chef from omnibus
# curl -L https://www.getchef.com/chef/install.sh | bash

sudo apt-get update
sudo aptitude install build-essential debootstrap python-pip automake libgmp3-dev libltdl-dev libunistring-dev libffi-dev ncurses-dev imagemagick libssl-dev pkg-config zlib1g-dev gettext git curl subversion check bjam intltool gperf flex bison xmlto php5 expect libgc-dev mercurial cython lzip
sudo pip install -U setuptools pip wheel

# display login promt after boot
sed "s/quiet splash//" /etc/default/grub > /tmp/grub
sed "s/GRUB_TIMEOUT=[0-9]/GRUB_TIMEOUT=0/" /tmp/grub > /etc/default/grub
update-grub

# clean up
apt-get clean

# Zero free space to aid VM compression
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
