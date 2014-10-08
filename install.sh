#!/bin/sh
# Installation script for Xv6 building tools on Mac OS X
# (see http://pdos.csail.mit.edu/6.828/2014/tools.html)

thisdir=$(cd $(dirname $0) && pwd)

. $thisdir/defs.sh

PATDIR=${thisdir}/patches

PATCH_GMP=${PATDIR}/${DIR_GMP}.patch
PATCH_MPFR=${PATDIR}/${DIR_MPFR}.patch
PATCH_MPC=${PATDIR}/${DIR_MPC}.patch
PATCH_BINUTILS=${PATDIR}/${DIR_BINUTILS}.patch
PATCH_GCC=${PATDIR}/${DIR_GCC}.patch
PATCH_GDB=${PATDIR}/${DIR_GDB}.patch

CMD_GET="curl -L -O"
#CMD_GET="wget"
TAR="tar"
GIT="git"

mkdir -p ${PREFIX}
mkdir -p ${SRCDIR}
mkdir -p ${ARCDIR}

# Obtaining phase

cd ${ARCDIR}
if [ ! -f ${PKG_GMP} ]; then ${CMD_GET} ${URL_GMP}; fi
if [ ! -f ${PKG_MPFR} ]; then ${CMD_GET} ${URL_MPFR}; fi
if [ ! -f ${PKG_MPC} ]; then ${CMD_GET} ${URL_MPC}; fi
if [ ! -f ${PKG_BINUTILS} ]; then ${CMD_GET} ${URL_BINUTILS}; fi
if [ ! -f ${PKG_GCC} ]; then ${CMD_GET} ${URL_GCC}; fi
if [ ! -f ${PKG_GDB} ]; then ${CMD_GET} ${URL_GDB}; fi

cd ${SRCDIR}
if [ ! -d ${DIR_QEMU} ]; then ${GIT} clone ${URL_QEMU} -b ${BR_QEMU}; fi

if [ ! -d ${DIR_GMP} ]; then ${TAR} xjf ${ARCDIR}/${PKG_GMP}; fi
if [ ! -d ${DIR_MPFR} ]; then ${TAR} xjf ${ARCDIR}/${PKG_MPFR}; fi
if [ ! -d ${DIR_MPC} ]; then ${TAR} xzf ${ARCDIR}/${PKG_MPC}; fi
if [ ! -d ${DIR_BINUTILS} ]; then ${TAR} xjf ${ARCDIR}/${PKG_BINUTILS}; fi
if [ ! -d ${DIR_GCC} ]; then ${TAR} xjf ${ARCDIR}/${PKG_GCC}; fi
if [ ! -d ${DIR_GDB} ]; then ${TAR} xjf ${ARCDIR}/${PKG_GDB}; fi

# Building phase

if [ ! -f ${PREFIX}/lib/libgmp.a ]; then
    echo Building and installing ${DIR_GMP}
    cd ${SRCDIR}/${DIR_GMP}
    if [ -f ${PATCH_GMP} ]; then patch -p1 < ${PATCH_GMP}; fi
    ./configure --prefix=$PREFIX
    make
    make install
fi

if [ ! -f ${PREFIX}/lib/libmpfr.a ]; then
    echo Building and installing ${DIR_MPFR}
    cd ${SRCDIR}/${DIR_MPFR}
    if [ -f ${PATCH_MPFR} ]; then patch -p1 < ${PATCH_MPFR}; fi
    ./configure --prefix=$PREFIX --with-gmp=$PREFIX
    make
    make install
fi

if [ ! -f ${PREFIX}/lib/libmpc.a ]; then
    echo Building and nstalling ${DIR_MPC}
    cd ${SRCDIR}/${DIR_MPC}
    if [ -f ${PATCH_MPC} ]; then patch -p1 < ${PATCH_MPC}; fi
    ./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX
    make
    make install
fi

if [ ! -x ${PREFIX}/bin/${TARGET}-as ]; then
    echo Building and installing ${DIR_BINUTILS}
    cd ${SRCDIR}/${DIR_BINUTILS}
    if [ -f ${PATCH_BINUTILS} ]; then patch -p1 < ${PATCH_BINUTILS}; fi
    ./configure --prefix=$PREFIX --target=$TARGET --disable-werror \
        --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-mpc=$PREFIX
    make
    make install
fi

if [ ! -x ${PREFIX}/bin/${TARGET}-gcc ]; then
    echo Building and installing ${DIR_GCC}
    cd ${SRCDIR}/${DIR_GCC}
    if [ -f ${PATCH_GCC} ]; then patch -p1 < ${PATCH_GCC}; fi
    mkdir build
    cd build
    ../configure --prefix=$PREFIX --target=$TARGET --disable-werror \
        --disable-libssp --disable-libmudflap --with-newlib \
        --without-headers --enable-languages=c \
        --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-mpc=$PREFIX
    make all-gcc
    make install-gcc
    make all-target-libgcc
    make install-target-libgcc
fi

if [ ! -x ${PREFIX}/bin/${TARGET}-gdb ]; then    
    echo Building and installing ${DIR_GDB}
    cd ${SRCDIR}/${DIR_GDB}
    if [ -f ${PATCH_GDB} ]; then patch -p1 < ${PATCH_GDB}; fi
    ./configure --prefix=$PREFIX --target=$TARGET \
        --program-prefix=$TARGET- --disable-werror \
        --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-mpc=$PREFIX
    make all
    make install
fi

if [ ! -x ${PREFIX}/bin/qemu-system-i386 ]; then
    echo Building and installing ${DIR_QEMU}
    cd ${SRCDIR}/${DIR_QEMU}
    if [ -f ${PATCH_QEMU} ]; then patch -p1 < ${PATCH_QEMU}; fi
    ./configure --prefix=$PREFIX --disable-kvm --disable-sdl \
        --target-list="i386-softmmu x86_64-softmmu"
    make
    make install
fi
