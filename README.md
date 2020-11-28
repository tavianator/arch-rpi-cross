Arch Linux cross-toolchain for Raspberry Pi
===========================================

This project will compile GCC for ARMv7 to provide the ABI that is required for
cross-compiling source code for Raspberry Pi and similar single board computers.

Usage
-----

```
$ git clone https://github.com/tavianator/arch-rpi-cross.git
$ cd arch-rpi-cross/
$ git submodule init
$ git submodule update
$ ./install.sh
```

The build is performed in multiple stages. After each stage is completed you
will be prompted to install the resulting package. The script will then proceed
automatically to the next stage.

Passing options
---------------

If desired you can add options for `makepkg` when invoking the script:

```
$ ./install.sh -Csf
```

Unattended build
----------------

To do an unattended build for CI or automated build systems, pass the
`--unattended` option. Any other options will be ignored.

```
$ ./install.sh --unattended
```
