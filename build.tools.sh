#!/bin/bash                                                                                                                                                                                                 

source config.sh

function install_xar(){                                                                                                                                                                            
    install_pkg "${CROSS_ROOT}/xar/xar" './autogen.sh'
    install_pkg "${CROSS_ROOT}/xar/xar" './configure'
    install_pkg "${CROSS_ROOT}/xar/xar" 'make'
    install_pkg "${CROSS_ROOT}/xar/xar" 'make install'
    ln -sf /usr/local/lib/libxar.so.1 /usr/lib/
    rm -rf ${CROSS_ROOT}/xar
}

function install_clang(){
    install_pkg "${CROSS_ROOT}/osxcross" "./build_clang.sh" "UNATTENDED=1" "INSTALLPREFIX=${CLANG_ROOT}"
    install_pkg "${CROSS_ROOT}/osxcross/build/llvm-3.9.1.src/build_stage2" 'make install'
    install_pkg "${CROSS_ROOT}/osxcross" "mv ${CROSS_ROOT}/MacOSX10.11.sdk.tar.xz tarballs/"
    install_pkg "${CROSS_ROOT}/osxcross" "./build.sh" "UNATTENDED=1" "PATH=${PATH}:${CLANG_ROOT}/bin"
    rm -rf ${CROSS_ROOT}/osxcross/build
}

function install_libtapi(){
    install_pkg "${CROSS_ROOT}/apple-libtapi" "./build.sh" "INSTALLPREFIX=${CROSS_ROOT}/osxcross/target" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/apple-libtapi" './install.sh'
    rm -rf ${CROSS_ROOT}/apple-libtapi
}

function install_cctools(){
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make clean"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "./configure --prefix=${CROSS_ROOT}/osxcross/target --with-libtapi=${CROSS_ROOT}/osxcross/target --with-llvm-config=${CLANG_ROOT}/bin/llvm-config --target=i386-apple-darwin11" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make install" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"

    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make clean"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "./configure --prefix=${CROSS_ROOT}/osxcross/target --with-libtapi=${CROSS_ROOT}/osxcross/target --with-llvm-config=${CLANG_ROOT}/bin/llvm-config --target=x86_64-apple-darwin11" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make install" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"

    rm -rf ${CROSS_ROOT}/cctools-port
}

install_xar
install_clang
install_libtapi
install_cctools
