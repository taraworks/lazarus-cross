#!/bin/bash

CROSS_ROOT="/opt"
CLANG_ROOT="${CROSS_ROOT}/clang"
CURR=`pwd`

function install_pkg(){
    cd ${1}
    if [ "${3}" != "" ];then
        export "${3}"
    fi
    if [ "${4}" != "" ];then
        export "${4}"
    fi
    if [ "${5}" != "" ];then
        export "${5}"
    fi
    if [ "${6}" != "" ];then
        export "${6}"
    fi
    if [ "${7}" != "" ];then
        export "${7}"
    fi
    if [ "${8}" != "" ];then
        export "${8}"
    fi
    if [ "${9}" != "" ];then
        export "${9}"
    fi
    if [ "${10}" != "" ];then
        export "${10}"
    fi
    if [ "${11}" != "" ];then
        export "${11}"
    fi
    if [ "${12}" != "" ];then
        export "${12}"
    fi
    if [ "${13}" != "" ];then
        export "${13}"
    fi
    if [ "${14}" != "" ];then
        export "${14}"
    fi
    if [ "${15}" != "" ];then
        export "${15}"
    fi
    if [ "${16}" != "" ];then
        export "${16}"
    fi
    #echo $PATH                                                                                                                                                                                             
    ${2}
    cd ${CURR}
}
