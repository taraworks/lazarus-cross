# Pull base image.
FROM ubuntu:16.04

# Install.
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y software-properties-common && \
  apt-get install -y curl git htop man unzip emacs-nox wget && \
  apt-get install -y clang fuse libfuse-dev libbz2-1.0 libbz2-dev && \
  apt-get install -y libbz2-ocaml libbz2-ocaml-dev cmake libgtk2.0-dev && \
  apt-get install -y libgpmg1-dev fakeroot libncurses5-dev zlib1g-dev && \
  apt-get install -y libxml2-dev autoconf automake libssl-dev && \
  wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc-src_3.0.4-2_amd64.deb && \
  wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/fpc_3.0.4-2_amd64.deb && \
  wget ftp://ftp.freepascal.org/pub/lazarus/releases/Lazarus%20Linux%20amd64%20DEB/Lazarus%201.8.0/lazarus-project_1.8.0-1_amd64.deb && \
  wget https://github.com/taraworks/lazarus-cross-sdk/raw/master/MacOSX10.11.sdk.tar.xz && mv MacOSX10.11.sdk.tar.xz /opt/ && \
  dpkg -i fpc-src_3.0.4-2_amd64.deb && \
  dpkg -i fpc_3.0.4-2_amd64.deb && \
  dpkg -i lazarus-project_1.8.0-1_amd64.deb

# Cleanup
RUN \
    rm -fv pc-src_3.0.4-2_amd64.deb fpc_3.0.4-2_amd64.deb lazarus-project_1.8.0-1_amd64.deb

# Get cross tools
RUN \
    git clone https://github.com/LongDirtyAnimAlf/osxcross /opt/osxcross && \
    git clone https://github.com/LongDirtyAnimAlf/cctools-port /opt/cctools-port && \   
    git clone https://github.com/tpoechtrager/apple-libtapi /opt/apple-libtapi && \
    git clone https://github.com/mackyle/xar /opt/xar

# Install xar
RUN \
    cd /opt/xar/xar && ./autogen.sh && \
    cd /opt/xar/xar && ./configure && \
    cd /opt/xar/xar && make && \
    cd /opt/xar/xar && make install && \
    ln -sf /usr/local/lib/libxar.so.1 /usr/lib/

# Build CLANG osxcross
RUN \
    cd /opt/osxcross && UNATTENDED=1 INSTALLPREFIX=/opt/clang ./build_clang.sh

# Install CLANG
RUN \
    cd /opt/osxcross/build/llvm-3.9.1.src/build_stage2 && make install && \
    cd /opt/osxcross && cp -fv /opt/MacOSX10.11.sdk.tar.xz tarballs/

# build osxcross tools
RUN \
    cd /opt/osxcross && UNATTENDED=1 PATH=${PATH}:/opt/clang/bin ./build.sh

# Install apple-libtapi
RUN \
    cd /opt/apple-libtapi && INSTALLPREFIX=/opt/osxcross/target PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin ./build.sh && \
    cd /opt/apple-libtapi && ./install.sh

# Install cctools
RUN \
    cd /opt/cctools-port/cctools && ./configure --prefix=/opt/osxcross/target --with-libtapi=/opt/osxcross/target --with-llvm-config=/opt/osxcross/target/bin/llvm-config --target=i386-apple-darwin11 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin  && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make install && \
    cd /opt/cctools-port/cctools && make clean  && \
    cd /opt/cctools-port/cctools && ./configure --prefix=/opt/osxcross/target --with-libtapi=/opt/osxcross/target --with-llvm-config=/opt/osxcross/target/bin/llvm-config --target=x86_64-apple-darwin11 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make  && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make install && \
    cd /opt/cctools-port/cctools && make clean  && \
    cd /opt/cctools-port/cctools && ./configure --prefix=/opt/osxcross/target --with-libtapi=/opt/osxcross/target --with-llvm-config=/opt/osxcross/target/bin/llvm-config --target=arm-apple-darwin11 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make && \
    cd /opt/cctools-port/cctools && PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin make install

# Build pascal compiler(s)
RUN \
    cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    cd /usr/share/fpcsrc/3.0.4 && make crossinstall CPU_TARGET=i386 OS_TARGET=darwin CROSSBINDIR=/opt/osxcross/target/bin BINUTILSPREFIX=i386-apple-darwin15- INSTALL_PREFIX=/opt/osxcross/target OPT=-gl -gw -godwarfsets -XX -CX -Xd -Fl/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib FPC=ppcross386 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin && \
    cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    cd /usr/share/fpcsrc/3.0.4 && make crossinstall CPU_TARGET=x86_64 OS_TARGET=darwin CROSSBINDIR=/opt/osxcross/target/bin BINUTILSPREFIX=x86_64-apple-darwin15- INSTALL_PREFIX=/opt/osxcross/target OPT=-gl -gw -godwarfsets -XX -CX -Xd -Fl/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib FPC=ppcrossx64 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin

    # echo "add the following lines to /etc/fpc.cfg"
    # echo "#IFDEF darwin"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/*"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/rtl"
    # echo "-FD//opt/osxcross/target/bin"
    # echo "#ENDIF"

# Add missing links
RUN \
    ln -sf /opt/osxcross/target/lib/fpc/3.0.4/units/i386-darwin /usr/lib/fpc/3.0.4/units/ && \
    ln -sf /opt/osxcross/target/lib/fpc/3.0.4/units/x86_64-darwin /usr/lib/fpc/3.0.4/units/ && \
    ln -sf /opt/osxcross/target/bin/i386-apple-darwin11-as /opt/osxcross/target/bin/i386-darwin-clang && \
    ln -sf /opt/osxcross/target/bin/i386-apple-darwin11-ld /opt/osxcross/target/bin/i386-darwin-ld

    # echo "PATH=\$PATH:/opt/clang/bin:/opt/osxcross/target/bin /opt/osxcross/target/lib/fpc/3.0.4/ppcross386 -Tdarwin -XR/opt/osxcross/target/SDK/MacOSX10.11.sdk -va hello.\
    # pas"

# Define default command.
CMD ["bash"]