#!/bin/bash                                                                                                                                                                                                 

source config.sh

function install_fpc(){
    cd ${CROSS_ROOT}
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc-src_3.0.4-2_amd64.deb
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc_3.0.4-2_amd64.deb
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/lazarus-project_1.8.0-1_amd64.deb
    dpkg -i fpc-src_3.0.4-2_amd64.deb
    dpkg -i fpc_3.0.4-2_amd64.deb
    dpkg -i lazarus-project_1.8.0-1_amd64.deb
    rm -fv fpc-src_3.0.4-2_amd64.deb fpc_3.0.4-2_amd64.deb lazarus-project_1.8.0-1_amd64.deb
}

function get_pkgs(){
    if [ ! -d "${CROSS_ROOT}/osxcross" ];then
        git clone https://github.com/LongDirtyAnimAlf/osxcross ${CROSS_ROOT}/osxcross
    fi
    if [ ! -d "${CROSS_ROOT}/cctools-port" ];then
        git clone https://github.com/LongDirtyAnimAlf/cctools-port ${CROSS_ROOT}/cctools-port
    fi
    if [ ! -d "${CROSS_ROOT}/apple-libtapi" ];then
        git clone https://github.com/tpoechtrager/apple-libtapi ${CROSS_ROOT}/apple-libtapi
    fi
    if [ ! -d "${CROSS_ROOT}/xar" ];then
        git clone https://github.com/mackyle/xar ${CROSS_ROOT}/xar
    fi
    # this is done by the Dockerfile if not uncomment the next lines
    # apt install -y \
    # clang \
    #     fuse \
    #     libfuse-dev \
    #     libbz2-1.0 \
    #     libbz2-dev \
    #     libbz2-ocaml \
    #     libbz2-ocaml-dev \
    #     cmake \
    #     libgtk2.0-dev \
    #     libgpmg1-dev \
    #     fakeroot \
    #     libncurses5-dev \
    #     zlib1g-dev \
    #     libxml2-dev \
    #     autoconf \
    #     automake
}

function install_crosstools(){
    ## install all pkgs                                                                                                                                                                                     
    install_pkg "${CROSS_ROOT}/xar/xar" './autogen.sh'
    install_pkg "${CROSS_ROOT}/xar/xar" './configure'
    install_pkg "${CROSS_ROOT}/xar/xar" 'make'
    install_pkg "${CROSS_ROOT}/xar/xar" 'make install'
    ln -sf /usr/local/lib/libxar.so.1 /usr/lib/

    install_pkg "${CROSS_ROOT}/osxcross" "./build_clang.sh" "UNATTENDED=1" "INSTALLPREFIX=${CLANG_ROOT}"
    install_pkg "${CROSS_ROOT}/osxcross/build/llvm-3.9.1.src/build_stage2" 'make install'
    install_pkg "${CROSS_ROOT}/osxcross" "cp -fv ${CROSS_ROOT}/MacOSX10.11.sdk.tar.xz tarballs/"
    install_pkg "${CROSS_ROOT}/osxcross" "./build.sh" "UNATTENDED=1" "PATH=${PATH}:${CLANG_ROOT}/bin"

    install_pkg "${CROSS_ROOT}/apple-libtapi" "./build.sh" "INSTALLPREFIX=${CROSS_ROOT}/osxcross/target" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/apple-libtapi" './install.sh'

    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make clean"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "./configure --prefix=${CROSS_ROOT}/osxcross/target --with-libtapi=${CROSS_ROOT}/osxcross/target --with-llvm-config=${CROSS_ROOT}/osxcross/target/bin/llvm-config --target=i386-apple-darwin11" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make install" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"

    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make clean"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "./configure --prefix=${CROSS_ROOT}/osxcross/target --with-libtapi=${CROSS_ROOT}/osxcross/target --with-llvm-config=${CROSS_ROOT}/osxcross/target/bin/llvm-config --target=x86_64-apple-darwin11" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make install" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"

    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make clean"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "./configure --prefix=${CROSS_ROOT}/osxcross/target --with-libtapi=${CROSS_ROOT}/osxcross/target --with-llvm-config=${CROSS_ROOT}/osxcross/target/bin/llvm-config --target=arm-apple-darwin11" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
    install_pkg "${CROSS_ROOT}/cctools-port/cctools" "make install" "PATH=${PATH}:${CLANG_ROOT}/bin:${CROSS_ROOT}/osxcross/target/bin"
}

get_pkgs
install_fpc
install_crosstools
build_cross_compilers

# echo "add the following lines to /etc/fpc.cfg"
# echo "#IFDEF darwin"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/*"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/rtl"
# echo "-FD/${CROSS_ROOT}/osxcross/target/bin"
# echo "#ENDIF"

# ln -sf ${CROSS_ROOT}/osxcross/target/lib/fpc/3.0.4/units/i386-darwin /usr/lib/fpc/3.0.4/units/
# ln -sf ${CROSS_ROOT}/osxcross/target/lib/fpc/3.0.4/units/x86_64-darwin /usr/lib/fpc/3.0.4/units/
# ln -sf ${CROSS_ROOT}/osxcross/target/bin/i386-apple-darwin11-as ${CROSS_ROOT}/osxcross/target/bin/i386-darwin-clang
# ln -sf ${CROSS_ROOT}/osxcross/target/bin/i386-apple-darwin11-ld ${CROSS_ROOT}/osxcross/target/bin/i386-darwin-ld

# echo "PATH=\$PATH:${CROSS_ROOT}/clang/bin:${CROSS_ROOT}/osxcross/target/bin ${CROSS_ROOT}/osxcross/target/lib/fpc/3.0.4/ppcross386 -Tdarwin -XR${CROSS_ROOT}/osxcross/target/SDK/MacOSX10.11.sdk -va hello.pas"
