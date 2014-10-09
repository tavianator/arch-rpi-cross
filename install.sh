#!/bin/bash

set -e

force=
if [ "$1" = "-f" ]; then
    force="-f"
fi

arch="$(uname -m)"
prefix=arm-linux-gnueabihf
binutils_version=2.24-1.1-${arch}
gcc_stage1_version=4.9.1-2-${arch}
linux_api_headers_version=3.16.1-1-any
glibc_headers_version=2.19-1.1-any
gcc_stage2_version=4.9.1-2-${arch}
glibc_version=2.19-1-any
gcc_version=4.9.1-2-${arch}

gcc_filename="gcc-${gcc_version%%-*}.tar.bz2"
glibc_filename="glibc-${glibc_version%%-*}.tar.bz2"

function build() {
    eval "version=\${${1//-/_}_version}"
    pkg="${prefix}-$1/${prefix}-$1-${version}.pkg.tar.xz"
    if [ -n "${force}" -o ! -f "${pkg}" ]; then
        (cd "./${prefix}-$1" && makepkg "${force}")
    fi
    sudo pacman -U "${pkg}"
}

build binutils
build gcc-stage1

build linux-api-headers
build glibc-headers
ln -s "../${prefix}-gcc-stage1/${gcc_filename}" "${prefix}-gcc-stage2/${gcc_filename}"
build gcc-stage2

ln -s "../${prefix}-glibc-headers/${glibc_filename}" "${prefix}-glibc/${glibc_filename}"
build glibc
ln -s "../${prefix}-gcc-stage2/${gcc_filename}" "${prefix}-gcc/${gcc_filename}"
build gcc
