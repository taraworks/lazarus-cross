#!/bin/bash

source config.sh

Bit32="i386"
Bit64="x86_64"

function build_cross_compilers(){
    # windows 32
    install_pkg "/usr/share/fpcsrc/3.0.4" "make distclean"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make all" "CPU_TARGET=${Bit32}" "OS_TARGET=win32"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make crossinstall" "CPU_TARGET=${Bit32}" "OS_TARGET=win32" "INSTALL_PREFIX=${CROSS_ROOT}/windows" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    # windows 64
    install_pkg "/usr/share/fpcsrc/3.0.4" "make distclean"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make all" "CPU_TARGET=${Bit64}" "OS_TARGET=win64"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make crossinstall" "CPU_TARGET=${Bit64}" "OS_TARGET=win64" "INSTALL_PREFIX=${CROSS_ROOT}/windows" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    # darwin 32
    install_pkg "/usr/share/fpcsrc/3.0.4" "make distclean"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make all" "CPU_TARGET=${Bit32}" "OS_TARGET=darwin"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make crossinstall" "CPU_TARGET=${Bit32}" "OS_TARGET=darwin" "CROSSBINDIR=${CROSS_ROOT}/osxcross/target/bin" "BINUTILSPREFIX=${Bit32}-apple-darwin15-" "INSTALL_PREFIX=${CROSS_ROOT}/darwin" "OPT=-gl -gw -godwarfsets -XX -CX -Xd -Fl${CROSS_ROOT}/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    # darwin 64
    install_pkg "/usr/share/fpcsrc/3.0.4" "make distclean"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make all" "CPU_TARGET=${Bit64}" "OS_TARGET=darwin"
    install_pkg "/usr/share/fpcsrc/3.0.4" "make crossinstall" "CPU_TARGET=${Bit64}" "OS_TARGET=darwin" "CROSSBINDIR=${CROSS_ROOT}/osxcross/target/bin" "BINUTILSPREFIX=${Bit64}-apple-darwin15-" "INSTALL_PREFIX=${CROSS_ROOT}/darwin" "OPT=-gl -gw -godwarfsets -XX -CX -Xd -Fl${CROSS_ROOT}/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
}

build_cross_compilers
