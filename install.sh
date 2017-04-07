#!/bin/bash

set -e

prefix="arm-linux-gnueabihf"
gcc_filename="4fc407888a30c5d953816b05c8a8e98ec2ab3101.tar.gz"
isl_filename="isl-0.16.1.tar.bz2"
glibc_filename="glibc-2.25.tar.xz"

args=("$@")

function build() {
    (cd "./${prefix}-$1" && makepkg -i "${args[@]}")
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
