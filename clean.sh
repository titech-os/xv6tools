#!/bin/sh
# xv6tools: Installation script for xv6 building tools on macOS
# Takuo Watanabe
# (see http://pdos.csail.mit.edu/6.828/2014/tools.html)

usage="Usage: $0 [--clean][--distclean][--sources][--archives][--installation][--prefix]"

thisdir=$(cd $(dirname $0) && pwd)

. $thisdir/defs.sh

clean_sources=
distclean_sources=
remove_sources=
remove_archives=
remove_installation=
remove_prefix=

while [ $# -gt 0 ]; do
    case "$1" in
    --clean) shift; clean_sources=y; break;;
    --distclean) shift; distclean_sources=y; break;;
    --sources) shift; remove_sources=y; break;;
    --archives) shift; remove_archives=y; break;;
    --installation) shift; remove_installation=y; break;;
    --prefix) shift; remove_prefix=y; break;;
    -*|--*) echo "Unknown option" $1; echo $usage; exit 2;;
    *) break;;
    esac
done

RM="rm -f"

N=`echo 'foo\c'`
case "$N" in
*c) n=-n c= ;;
*) n= c='\c' ;;
esac

if [ -n "$remove_prefix" ]; then
    really_remove_prefix=
    echo $n "Note: Removing $PREFIX permanently. Are you sure? [yes/No] $c"
    read ans
    case "$ans" in
    yes|Yes) really_remove_prefix=y;;
    esac
    if [ -n "$really_remove_prefix" ]; then
        $RM -r $PREFIX
    fi
    exit
fi

ds="bin etc $TARGET include lib libexec share var"

if [ -n "$remove_installation" ]; then
    dds="{`echo $ds | tr ' ' ','`}"
    really_remove_installation=
    echo $n "Note: Removing $PREFIX/$dds permanently. Are you sure? [yes/No] $c"
    read ans
    case "$ans" in
    yes|Yes) really_remove_installation=y;;
    esac
    if [ -n "$really_remove_installation" ]; then
        for d in $ds; do
            $RM -r $PREFIX/$d
        done
    fi
    exit
fi

if [ -n "$remove_sources" ]; then
    cd $SRCDIR
    $RM -r $DIR_BINUTILS
    $RM -r $DIR_GCC
    $RM -r $DIR_GDB
    exit
fi

if [ -n "$remove_archives" ]; then
    cd $ARCDIR
    $RM $PKG_BINUTILS
    $RM $PKG_GCC
    $RM $PKG_GDB
    exit
fi

if [ -n "$distclean_sources" ]; then
    cd $SRCDIR/$DIR_BINUTILS
    make distclean
    cd $SRCDIR/$DIR_GCC/build
    make distclean
    cd $SRCDIR/$DIR_GCC
    rm -rf build
    cd $SRCDIR/$DIR_GDB
    make distclean
    exit
fi

if [ -n "$clean_sources" ]; then
    cd $SRCDIR/$DIR_BINUTILS
    make clean
    cd $SRCDIR/$DIR_GCC/build
    make clean
    cd $SRCDIR/$DIR_GDB
    make clean
    exit
fi
