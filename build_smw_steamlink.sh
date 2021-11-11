#!/bin/bash
#
echo "Checking For SDK..."
source "../../setenv.sh"
git submodule update --init
rm -r build 2> /dev/null || echo > /dev/null
mkdir build 2> /dev/null || echo > /dev/null
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../toolchain/steamlink-toolchain.cmake -DUSE_SDL2_LIBS=1 -DSDL2_FORCE_GLES=1 ..
make smw || exit 2

# Prepare package directory
rm "../output/smw-steamlink/smw" 2> /dev/null || echo > /dev/null
rm "../output/smw" 2> /dev/null || echo > /dev/null

cp "./Binaries/Release/smw" "../output/smw-steamlink/smw"
cp "./Binaries/Release/smw" "../output/smw"

cd ..
rm -r build 2> /dev/null || echo > /dev/null

echo "Packaging it for Steam-Link...."
export DESTDIR="${PWD}/output/smw-steamlink"
cd output

# Pack it up
name=$(basename ${DESTDIR})
tar zcf $name.tgz $name || exit 3
rm "./smw-steamlink/smw" 2> /dev/null || echo > /dev/null
echo "Build Complete! Check in /output/ directory."
