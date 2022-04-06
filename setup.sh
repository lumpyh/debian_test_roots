#!/bin/bash

DIR="rootfs_test"
PACKAGES="ssh,git,vim,sudo,make,autoconf,autogen,libtool,fuse,pkg-config,libfuse-dev"
ARCH="amd64"
SUITE="stable"
USER_NAME="test"
XENOMAI_BRANCH="stable/v3.2.x"
XENOMAI_MIRROR=https://source.denx.de/Xenomai/xenomai.git

make_rootfs(){
	sudo debootstrap --arch=$ARCH --include=$PACKAGES $SUITE $DIR
}

create_user(){
	sudo chroot $DIR useradd -m -s /bin/bash $USER_NAME
	# enable sudo for user
	sudo bash -c "echo $USER_NAME  ALL=\(ALL:ALL\) ALL >> $DIR/etc/sudoers"
	# set bashrc ll alias
 	echo "alias ll=\"ls -hl\"" >> $DIR/home/$USER_NAME/.bashrc
}

clone_xenomai(){
	# save currend dir to jump back to it at end
	CURRENT_DIR=`pwd`

	# clone currend xenomai
	cd $DIR/home/$USER_NAME
	git clone $XENOMAI_MIRROR

	# checkout branch
	cd xenomai
	git checkout $XENOMAI_BRANCH
	
	# jump back to dir we enterd in
	cd $CURRENT_DIR
}

make_rootfs
create_user
clone_xenomai
