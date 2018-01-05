# Pull base image.
FROM ubuntu:16.04

# Update.
RUN \
    apt-get update && \
    apt-get -y upgrade

# Upgrade and install all required pkgs
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl git htop man unzip emacs-nox wget && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y clang fuse libfuse-dev libbz2-1.0 libbz2-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libbz2-ocaml libbz2-ocaml-dev cmake libgtk2.0-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libgpmg1-dev fakeroot libncurses5-dev zlib1g-dev && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libxml2-dev autoconf automake libssl-dev

# Add building scripts
ADD config.sh /
ADD build.tools.sh /
ADD compilers.sh /

# Build the cross tools
RUN \
    chmod +x /config.sh && \
    chmod +x /build.tools.sh && \
    /build.tools.sh

# Build the cross compilers
RUN \
    chmod +x /config.sh && \
    chmod +x /compilers.sh && \
    /compilers.sh

# Build pascal compiler(s)
# RUN \
#     cd /usr/share/fpcsrc/3.0.4 && make distclean && \
#     cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=win32 make all && \
#     cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=win32 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin:/usr/lib/fpc/3.0.4 make crossinstall && \
    # cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=win64 make all && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=x86_64 OS_TARGET=win64 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin:/usr/lib/fpc/3.0.4 make crossinstall && \
    # cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=linux make all && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=linux PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin:/usr/lib/fpc/3.0.4 make crossinstall && \
    # cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=i386 OS_TARGET=darwin CROSSBINDIR=/opt/osxcross/target/bin BINUTILSPREFIX=i386-apple-darwin15- INSTALL_PREFIX=/opt/osxcross/target OPT="-gl -gw -godwarfsets -XX -CX -Xd -Fl/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib" FPC=ppcross386 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin:/usr/lib/fpc/3.0.4 make crossinstall && \
    # cd /usr/share/fpcsrc/3.0.4 && make distclean && \
    # cd /usr/share/fpcsrc/3.0.4 && CPU_TARGET=x86_64 OS_TARGET=darwin CROSSBINDIR=/opt/osxcross/target/bin BINUTILSPREFIX=x86_64-apple-darwin15- INSTALL_PREFIX=/opt/osxcross/target OPT="-gl -gw -godwarfsets -XX -CX -Xd -Fl/opt/osxcross/target/SDK/MacOSX10.11.sdk/usr/lib" FPC=ppcx64 PATH=${PATH}:/opt/clang/bin:/opt/osxcross/target/bin:/usr/lib/fpc/3.0.4 make crossinstall

    # echo "add the following lines to /etc/fpc.cfg"
    # echo "#IFDEF darwin"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/*"
    # echo "-Fu/opt/osxcross/target/lib/fpc/$fpcversion/units/i386-darwin/rtl"
    # echo "-FD//opt/osxcross/target/bin"
    # echo "#ENDIF"

# Add missing links
# RUN \
#     ln -sf /opt/osxcross/target/lib/fpc/3.0.4/units/i386-darwin /usr/lib/fpc/3.0.4/units/ && \
#     ln -sf /opt/osxcross/target/lib/fpc/3.0.4/units/x86_64-darwin /usr/lib/fpc/3.0.4/units/ && \
#     ln -sf /opt/osxcross/target/bin/i386-apple-darwin11-as /opt/osxcross/target/bin/i386-darwin-clang && \
#     ln -sf /opt/osxcross/target/bin/i386-apple-darwin11-ld /opt/osxcross/target/bin/i386-darwin-ld

    # echo "PATH=\$PATH:/opt/clang/bin:/opt/osxcross/target/bin /opt/osxcross/target/lib/fpc/3.0.4/ppcross386 -Tdarwin -XR/opt/osxcross/target/SDK/MacOSX10.11.sdk -va hello.\
    # pas"

# Define default command.
CMD ["bash"]