#!/bin/bash

die() {
	echo "$@"
	exit 1
}

case $OS in
	debian|Gentoo)
		;;
	debian|Debian)
		;;
	*)
		die "unsupported OS $OS!"
		;;
esac
