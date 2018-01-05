#!/bin/bash


# echo "add the following lines to /etc/fpc.cfg"
# echo "#IFDEF darwin"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/*"
# echo "-Fu${CROSS_ROOT}/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/rtl"
# echo "-FD/${CROSS_ROOT}/osxcross/target/bin"
# echo "#ENDIF"

echo 'program Hello;' > hello.pas
echo 'begin' >> hello.pas
echo "    writeln ('Hello, world.')" >> hello.pas
echo 'end.' >> hello.pas

echo "building hello.exe for win32"
PATH=$PATH:${CROSS_ROOT}/clang/bin:${CROSS_ROOT}/osxcross/target/bin ${CROSS_ROOT}/windows/lib/fpc/3.0.4/ppcross386 -Twin32 -va hello.pas

echo "building hello for darwin32"
PATH=$PATH:${CROSS_ROOT}/clang/bin:${CROSS_ROOT}/osxcross/target/bin ${CROSS_ROOT}/darwin/lib/fpc/3.0.4/ppcross386 -Tdarwin -XR${CROSS_ROOT}/osxcross/target/SDK/MacOSX10.11.sdk -va hello.pas
