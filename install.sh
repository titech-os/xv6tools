#!/bin/sh
# xv6tools: Installation script for xv6 building tools on macOS
# Takuo Watanabe
# (see http://pdos.csail.mit.edu/6.828/2017/tools.html)

thisdir=$(cd $(dirname $0) && pwd)

. $thisdir/defs.sh

PATDIR=${thisdir}/patches

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

for p in ${LIB_PREFIX_LIST}; do
    if [ -f $p/lib/libgmp.dylib -a \
         -f $p/lib/libmpfr.dylib -a \
         -f $p/lib/libmpc.dylib ]; then
        LIB_PREFIX=$p
        break
    fi
done
if [ "x${LIB_PREFIX}" = "x" ]; then
    echo "Error: GMP, MPFR and MPC are required"
    exit 1
fi

LIBICONV_CONFIG_OPTION=
if [ -f ${LIB_PREFIX}/lib/libiconv.dylib ]; then
    LIBICONV_CONFIG_OPTION="--with-libiconv-prefix=${LIB_PREFIX}"
fi

if [ ! `which pkg-config` ]; then
    echo "Error: pkg-config is required"
    exit 1
fi

# Obtaining phase

cd ${ARCDIR}
if [ ! -f ${PKG_BINUTILS} ]; then ${CMD_GET} ${URL_BINUTILS}; fi
if [ ! -f ${PKG_GCC} ]; then ${CMD_GET} ${URL_GCC}; fi
if [ ! -f ${PKG_GDB} ]; then ${CMD_GET} ${URL_GDB}; fi

cd ${SRCDIR}
if [ ! -d ${DIR_BINUTILS} ]; then ${TAR} xjf ${ARCDIR}/${PKG_BINUTILS}; fi
if [ ! -d ${DIR_GCC} ]; then ${TAR} xjf ${ARCDIR}/${PKG_GCC}; fi
if [ ! -d ${DIR_GDB} ]; then ${TAR} xjf ${ARCDIR}/${PKG_GDB}; fi

# Building phase

if [ ! -x ${PREFIX}/bin/${TARGET}-as ]; then
    echo Building and installing ${DIR_BINUTILS}
    cd ${SRCDIR}/${DIR_BINUTILS}
    if [ -f ${PATCH_BINUTILS} ]; then patch -p1 < ${PATCH_BINUTILS}; fi
    ./configure --prefix=$PREFIX --target=$TARGET --disable-werror \
        --with-gmp=$LIB_PREFIX --with-mpfr=$LIB_PREFIX --with-mpc=$LIB_PREFIX
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
        --with-gmp=$LIB_PREFIX --with-mpfr=$LIB_PREFIX --with-mpc=$LIB_PREFIX \
	${LIBICONV_CONFIG_OPTION}
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
        --with-gmp=$LIB_PREFIX --with-mpfr=$LIB_PREFIX --with-mpc=$LIB_PREFIX
    make all
    make install
fi

