# defs.sh

PREFIX=${PREFIX:-/opt/os}
#PREFIX=~/xv6tools
SRCDIR=${SRCDIR:-$PREFIX/src}
ARCDIR=${ARCDIR:-$SRCDIR/archive}

TARGET=i386-jos-elf

VER_GMP=5.0.2
VER_MPFR=3.1.2
VER_MPC=0.9
VER_BINUTILS=2.21.1
VER_GCC=4.6.1
VER_GDB=7.3.1
BR_QEMU=6.828-1.7.0

DIR_GMP=gmp-${VER_GMP}
DIR_MPFR=mpfr-${VER_MPFR}
DIR_MPC=mpc-${VER_MPC}
DIR_BINUTILS=binutils-${VER_BINUTILS}
DIR_GCC=gcc-${VER_GCC}
DIR_GDB=gdb-${VER_GDB}
DIR_QEMU=qemu

PKG_GMP=${DIR_GMP}.tar.bz2
PKG_MPFR=${DIR_MPFR}.tar.bz2
PKG_MPC=${DIR_MPC}.tar.gz
PKG_BINUTILS=${DIR_BINUTILS}.tar.bz2
PKG_GCC=gcc-core-${VER_GCC}.tar.bz2
PKG_GDB=${DIR_GDB}.tar.bz2

URL_GMP=ftp://ftp.gmplib.org/pub/${DIR_GMP}/${PKG_GMP}
URL_MPFR=http://www.mpfr.org/mpfr-current/${PKG_MPFR}
URL_MPC=http://www.multiprecision.org/mpc/download/${PKG_MPC}
URL_BINUTILS=http://ftpmirror.gnu.org/binutils/${PKG_BINUTILS}
URL_GCC=http://ftpmirror.gnu.org/gcc/${DIR_GCC}/${PKG_GCC}
URL_GDB=http://ftpmirror.gnu.org/gdb/${PKG_GDB}
URL_QEMU=https://github.com/geofft/qemu.git
