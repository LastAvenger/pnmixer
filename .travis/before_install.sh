#!/bin/bash

die() {
	echo "$@"
	exit 1
}

case $OS in
	gentoo|Gentoo)
		# pull the image which includes dependencies
		docker pull hasufell/gentoo-pnmixer-test:latest \
			|| die "failed to pull docker image!"
		;;
	debian|Debian)
		# pull base image
		docker pull debian:unstable \
			|| die "failed to pull docker image!"

		# create our Dockerfile specific for pnmixer
		cat <<'EOF' > Dockerfile
FROM debian:unstable

ENV DEBIAN_FRONTEND=noninteractive

# update the package repositories
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget curl locales

# Configure timezone and locale
RUN echo "Europe/Stockholm" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	dpkg-reconfigure locales

# install pnmixer dependencies
RUN apt-get install -y libgtk-3-0 libgtk-3-bin libgtk-3-dev libgtk-3-common \
	libgtk2.0 libgtk2.0-bin libgtk2.0-cil libgtk2.0-cil-dev \
	libgtk2.0-common libgtk2.0-dev \
	libx11-6 libx11-data libx11-dev \
	libglib2.0-0 libglib2.0-bin libglib2.0-cil libglib2.0-cil-dev \
	libglib2.0-data libglib2.0-dev \
	libnotify-bin libnotify-cil-dev libnotify-dev \
	intltool gettext pkg-config automake autoconf \
	libasound2 libasound2-data libasound2-dev \
	clang
EOF
		docker build -t pnmixer-debian-test . \
			|| die "failed to create docker image"
		;;
	*)
		die "unsupported OS $OS!"
		;;
esac
