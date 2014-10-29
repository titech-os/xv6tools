xv6tools
======
Installation script for xv6 building tools (for Mac OS X)

This script installs an i368-elf toolchain (binutils, gcc and gdb) and a PC emulator (QEMU). See the following site for details on what will be installed.

* http://pdos.csail.mit.edu/6.828/2014/tools.html

Usage
------

In prior to use the script, install required libraries and tools. Use of a package management system (such as HomeBrew or MacPorts) is recommended.

HomeBrew:

    $ brew install libmpc glib pixman

MacPorts:

    $ sudo port install libmpc libpixman

Then, install the toolchain and QEMU with `install.sh`.

    $ sh install.sh

The default installation prefix is `/opt/os`. If you don't have enough right to write in the directory, you should use `sudo`.

    $ sudo sh install.sh

If you want to specify an installation prefix other than the default (`/opt/os`), edit `defs.sh` or do like the following.

    $ PREFIX=~/xv6tools sh install.sh

The above example command installs under `~/xv6tools` instead of `/opt/os`.

After successful installation, use `clean.sh` script to cleanup the source directories.

    $ sh clean.sh --clean
