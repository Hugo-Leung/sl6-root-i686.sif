#!/bin/bash
set -ex 
cd /opt

tar xvf root-source.tar.gz
cd root	

sed -i 's/FREE_CFLAGS="-m32";/FREE_CFLAGS="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE";/g' graf2d/freetype/Module.mk
sed -i 's/ACC="\$\$ACC -m32"/ACC="\$\$ACC -m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' graf2d/asimage/Module.mk
sed -i 's/PCRE_CFLAGS="-m32"/PCRE_CFLAGS="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' core/pcre/Module.mk
sed -i 's/LZMACC="\$\$LZMACC -m32"/LZMACC="\$\$LZMACC -m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' core/lzma/Module.mk
sed -i 's/LZMA_CFLAGS="-m32"/LZMA_CFLAGS="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' core/lzma/Module.mk
sed -i 's/LZ4CC="\$\$LZ4CC -m32"/LZ4CC="\$\$LZ4CC -m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' core/lz4/Module.mk
sed -i 's/LZ4_CFLAGS="-m32"/LZ4_CFLAGS="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"/g' core/lz4/Module.mk

export CFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"
export CXXFLAGS="-D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE"
linux32 ./configure \
  --cxxflags="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE" \
  --cflags="-m32 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE" \
  --disable-builtin-lz4  \
  --enable-builtin-freetype \
  --disable-xrootd \
  --enable-soversion \
  --enable-minuit2 \
  --enable-qt 

linux32 make -j3
