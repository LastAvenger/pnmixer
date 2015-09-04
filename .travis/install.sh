#!/bin/bash

die() {
	echo "$@"
	exit 1
}

case $OS in
	Gentoo)
		;;
	*)
		die "unsupported OS $OS!"
		;;
esac
