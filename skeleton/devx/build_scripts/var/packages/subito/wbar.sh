#!/bin/sh

PKG_NAME="wbar"
PKG_VER="2.3.0"
PKG_REV="1"
PKG_DESC="Lightweight dock"
PKG_CAT="Desktop"
PKG_DEPS="+imlib2"

download() {
	[ -f ${PKG_NAME}_${PKG_VER}.orig.tar.gz ] && return 0
	# download the sources tarball
	download_file http://wbar.googlecode.com/files/${PKG_NAME}_${PKG_VER}.orig.tar.gz
	[ $? -ne 0 ] && return 1
	return 0
}

build() {
	# extract the sources tarball
	tar -xzvf ${PKG_NAME}_${PKG_VER}.orig.tar.gz
	[ $? -ne 0 ] && return 1

	cd $PKG_NAME-$PKG_VER

	# configure the package
	./configure $AUTOTOOLS_BASE_OPTS \
	            --disable-wbar-config
	[ $? -ne 0 ] && return 1

	# build the package
	make -j $BUILD_THREADS
	[ $? -ne 0 ] && return 1

	return 0
}

package() {
	# install the package
	make DESTDIR=$INSTALL_DIR install
	[ $? -ne 0 ] && return 1

	# remove an unneeded directory
	rm -rf $INSTALL_DIR/$SHARE_DIR/wbar/glade
	[ $? -ne 0 ] && return 1

	# remove XDG-related stuff
	rm -rf $INSTALL_DIR/$CONF_DIR/xdg
	[ $? -ne 0 ] && return 1

	# install the list of authors
	install -D -m644 AUTHORS $INSTALL_DIR/$LEGAL_DIR/$PKG_NAME/AUTHORS
	[ $? -ne 0 ] && return 1

	return 0
}
