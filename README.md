xv6tools
======
Installation script for Xv6 building tools (for Mac OS X)

This script installs an i368-elf toolchain (binutils, gcc, gdb and related libraries) and a PC emulator (QEMU). See the following site for details on what will be installed.

* http://pdos.csail.mit.edu/6.828/2014/tools.html

Usage
------
To install the toolchain and QEMU, use the script `install.sh` as follows.

    $ sh install.sh

This will first download the source code archives of the libraries and tools, then build and install them under `/opt/os`. If you don't have the rights to write in the directory, you should use `sudo` as:

    $ sudo sh install.sh

To specify the destination other than the default directory (`/opt/os`), edit defs.sh or do like the following.

    $ PREFIX=~/xv6tools sh install.sh

The above example command installs under `~/xv6tools` instead of `/opt/os`.

Use `clean.sh` script to cleanup the source directories after successful installation.

    $ sh clean.sh --clean
