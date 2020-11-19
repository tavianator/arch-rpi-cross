#!/bin/bash

set -e

prefix="arm-linux-gnueabihf"
gcc_filename="gcc-10.1.0.tar.xz"
isl_filename="isl-0.21.tar.xz"
glibc_filename="glibc-2.31.tar.xz"

args=("$@")

function build() {
    (
        cd "./${prefix}-$1"
        package_filename=$(makepkg --packagelist)
        if [[ ! -f "$package_filename" ]] ; then
          makepkg --clean --noconfirm "${args[@]}"
        fi
        sudo pacinstall --file "$package_filename" --resolve-conflicts=all --no-confirm
    )
}

build binutils

build gcc-stage1

build linux-api-headers

build glibc-headers

ln -sf "../${prefix}-gcc-stage1/${gcc_filename}" "${prefix}-gcc-stage2/"
ln -sf "../${prefix}-gcc-stage1/${isl_filename}" "${prefix}-gcc-stage2/"
build gcc-stage2

ln -sf "../${prefix}-glibc-headers/${glibc_filename}" "${prefix}-glibc/"
build glibc

ln -sf "../${prefix}-gcc-stage2/${gcc_filename}" "${prefix}-gcc/"
ln -sf "../${prefix}-gcc-stage2/${isl_filename}" "${prefix}-gcc/"
build gcc
