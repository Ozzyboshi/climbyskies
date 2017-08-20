from ubuntu:16.10

RUN mkdir /project
RUN mkdir /project/downloads
RUN mkdir /project/build
RUN mkdir /project/repos
RUN mkdir /usr/local/amiga
RUN mkdir /usr/local/amiga/vgcc
RUN mkdir /usr/local/amiga/vgcc/bin
RUN mkdir /usr/local/amiga/vgcc/ndk
RUN mkdir /usr/local/amiga/vgcc/ndk/include
RUN mkdir /usr/local/amiga/vgcc/ndk/lib

RUN apt-get update
RUN apt-get install -y curl wget m4 make autotools-dev libdata-dumper-simple-perl git pkg-config zlib1g-dev sox automake

WORKDIR /project/downloads
RUN curl -OL http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz
RUN curl -OL http://ftpmirror.gnu.org/automake/automake-1.15.tar.gz
RUN curl -O http://www.haage-partner.de/download/AmigaOS/NDK39.lha
RUN curl -OL http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
RUN curl -OL ftp://ftp.simplesystems.org/pub/png/src/libpng16/libpng-1.6.31.tar.gz
RUN curl -OL http://78.108.103.11/MIRROR/ftp/GraphicsMagick/1.3/GraphicsMagick-1.3.23.tar.gz
RUN curl -OL  https://cmake.org/files/v3.5/cmake-3.5.1-Darwin-x86_64.tar.gz
RUN curl -OL http://sun.hasenbraten.de/vlink/release/vlink.tar.gz
RUN curl -OL http://sun.hasenbraten.de/vasm/release/vasm.tar.gz

WORKDIR /project/repos
RUN git clone https://github.com/jca02266/lha.git
RUN git clone git://github.com/pornel/pngquant.git
RUN git clone https://github.com/baylej/tmx.git
RUN git clone https://github.com/alpine9000/gcc.git
RUN git clone https://github.com/alpine9000/climbyskies.git

WORKDIR /project/repos/lha
RUN aclocal && autoheader && automake -a && autoconf && ./configure --prefix=/usr/local && make && make install 

WORKDIR /project/build
RUN tar xzf ../downloads/autoconf-2.69.tar.gz
RUN tar xzf ../downloads/automake-1.15.tar.gz
RUN lha x ../downloads/NDK39.lha
RUN tar zxfv ../downloads/libtool-2.4.6.tar.gz
RUN tar zxfv ../downloads/libpng-1.6.28.tar.gz
RUN tar zxfv ../downloads/GraphicsMagick-1.3.23.tar.gz
RUN tar zxfv ../downloads/cmake-3.5.1-Darwin-x86_64.tar.gz
RUN tar zxfv ../downloads/vlink.tar.gz 
RUN tar zxfv ../downloads/vasm.tar.gz

WORKDIR /project/build/autoconf-2.69
RUN ./configure --prefix=/usr/local && make && make install

WORKDIR /project/build/automake-1.15
RUN ./configure --prefix=/usr/local && make && make install

WORKDIR /project/build
RUN cp -r NDK_3.9/Include/include_i/* /usr/local/amiga/vgcc/ndk/include/
RUN cp -r NDK_3.9/Include/include_h/* /usr/local/amiga/vgcc/ndk/include/
RUN cp -r NDK_3.9/Include/linker_libs/* /usr/local/amiga/vgcc/ndk/lib

WORKDIR ~/project/build/libtool-2.4.6
RUN ./configure --prefix=/usr/local && make && make install

WORKDIR /project/build/libpng-1.6.31
RUN ./configure --prefix=/usr/local && make && make install

WORKDIR ~/project/build/pngquant
RUN ./configure --prefix=/usr/local
RUN cd lib
RUN ./configure --prefix=/usr/local && make && mkdir /usr/local/include/pngquant && cp *.h /usr/local/include/pngquant/ && cp *.a /usr/local/lib

WORKDIR /project/build/GraphicsMagick-1.3.23
RUN ./configure --prefix=/usr/local && make && make install

WORKDIR ~/project/build/
RUN mv cmake-3.5.1-Darwin-x86_64/CMake.app /Applications

WORKDIR ~/project/build/sox
RUN autoreconf -i && ./configure --prefix=/usr/local && make install

WORKDIR ~/project/build/vasm
RUN make CPU=m68k SYNTAX=mot && cp vasmm68k_mot /usr/local/amiga/vgcc/bin/

WORKDIR /project/repos/gcc
RUN  ./contrib/download_prerequisites
WORKDIR ~/project/build/vasm
RUN mkdir gcc && cd gcc && ./../repos/gcc/configure --prefix=/usr/local/amiga/vgcc --target=m68k-amigaos --enable-languages=c ----with-as=/usr/local/amiga/vgcc/bin/vasmm68k_mot
RUN make -j4 all-gcc
RUN make -j4 install-gcc

#WORKDIR ~/project/repos/climbyskies
#RUN make


CMD /bin/bash
