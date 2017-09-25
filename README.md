xv6tools
======
Installation script for xv6 building tools (for macOS)

This script installs an i368-elf toolchain (binutils, gcc and gdb) and a patched version of QEMU. See the following site for details on what will be installed.

* http://pdos.csail.mit.edu/6.828/2017/tools.html

Usage
------

Before using the script, be sure to install required libraries and tools. Use of a package management system (such as HomeBrew or MacPorts) is recommended.

HomeBrew:

    $ brew install libmpc glib pixman pkgconfig

MacPorts:

    $ sudo port install libmpc libpixman pkgconfig

Then, install the toolchain with `install.sh`.

    $ sh install.sh

The default installation prefix is `/opt/os`. If you don't have enough right to write in the directory, you should use `sudo`.

    $ sudo sh install.sh

If you want to specify an installation prefix other than the default (`/opt/os`), edit `defs.sh` or do like the following.

    $ PREFIX=~/xv6tools sh install.sh

This example command installs under `~/xv6tools` instead of `/opt/os`.

After successful installation, use `clean.sh` script to cleanup the source directories.

    $ sh clean.sh --clean

Note: Building of gcc may fail if you have a recent version (>= 5.2) of texinfo package installed with MacPorts. To avoid this, deactivate texinfo temporarily.

    $ sudo port -f deactivate texinfo
    $ sh install.sh
    $ sudo port -f activate texinfo

