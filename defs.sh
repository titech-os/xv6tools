#!/bin/sh
# xv6tools: Installation script for xv6 building tools on Mac OS X
# Takuo Watanabe
# (see http://pdos.csail.mit.edu/6.828/2014/tools.html)

PREFIX=${PREFIX:-/opt/os}
#PREFIX=~/xv6tools
SRCDIR=${SRCDIR:-$PREFIX/src}
ARCDIR=${ARCDIR:-$SRCDIR/archive}

LIB_PREFIX_LIST="/usr /usr/local /opt/local"

TARGET=i386-jos-elf

VER_BINUTILS=2.21.1
VER_GCC=4.6.1
VER_GDB=7.3.1
BR_QEMU=6.828-1.7.0

DIR_BINUTILS=binutils-${VER_BINUTILS}
DIR_GCC=gcc-${VER_GCC}
DIR_GDB=gdb-${VER_GDB}
DIR_QEMU=qemu

PKG_BINUTILS=${DIR_BINUTILS}.tar.bz2
PKG_GCC=gcc-core-${VER_GCC}.tar.bz2
PKG_GDB=${DIR_GDB}.tar.bz2

URL_BINUTILS=http://ftpmirror.gnu.org/binutils/${PKG_BINUTILS}
URL_GCC=http://ftpmirror.gnu.org/gcc/${DIR_GCC}/${PKG_GCC}
URL_GDB=http://ftpmirror.gnu.org/gdb/${PKG_GDB}
URL_QEMU=https://github.com/geofft/qemu.git
