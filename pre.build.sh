#!/bin/bash                                                                                                                                                                                                 

source config.sh

function install_fpc(){
    cd ${CROSS_ROOT}
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc-src_3.0.4-2_amd64.deb
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc_3.0.4-2_amd64.deb
    wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/lazarus-project_1.8.0-1_amd64.deb
    wget https://github.com/taraworks/lazarus-cross-sdk/raw/master/MacOSX10.11.sdk.tar.xz
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
}

get_pkgs
install_fpc
