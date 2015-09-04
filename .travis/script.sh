#!/bin/bash

die() {
	echo "$@"
	exit 1
}

case $OS in
	gentoo|Gentoo)
		docker run -ti \
			-v "`pwd`":/pnmixer \
			hasufell/gentoo-pnmixer-test:latest \
			sh -c "cd /pnmixer && CC=$CC ./autogen.sh --enable-debug $BUILD_FLAGS && make" \
			|| die "failed to build image"
		;;
	debian|Debian)
		docker run -ti \
			-v "`pwd`":/pnmixer \
			pnmixer-debian-test \
			sh -c "cd /pnmixer && CC=$CC ./autogen.sh --enable-debug $BUILD_FLAGS && make" \
			|| die "failed to build image"
		;;
	*)
		die "unsupported OS: $OS!"
		;;
esac

