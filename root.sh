#!/bin/bash
set -e 
cd /opt

tar xvf root_v5.34.38.source.tar.gz
cd root	

sed -i 's/FREE_CFLAGS="-m32";/FREE_CFLAGS="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE";/g' graf2d/freetype/Module.mk

export CFLAGS="-D_FILE_OFFSET_BITS=64"
export CXXFLAGS="-D_FILE_OFFSET_BITS=64"
linux32 ./configure linux --cxxflags="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE" --cflags="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE" \
--disable-builtin-lz4  --enable-builtin-freetype --disable-xrootd --enable-soversion --enable-minuit2 --enable-qt 

linux32 make -j3
