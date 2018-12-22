#!/bin/sh

CURRENT_PATH=$(pwd)
IJKPLAYER_PATH="../ijkplayer-ios"

echo "\x1B[1;34m ******************** \x1B[0m"
git clone https://github.com/Bilibili/ijkplayer "${IJKPLAYER_PATH}"
cd "${IJKPLAYER_PATH}"
git checkout -B latest k0.8.8

echo "\x1B[1;34m Downloading ffmpeg... \x1B[0m"
sh ./init-ios.sh

echo "\x1B[1;34m Downloading open ssl... \x1B[0m"
sh ./init-ios-openssl.sh

echo "\x1B[1;34m Perpare to build ffmpeg \x1B[0m"
cd ./ios/
# remove armv7 in ios8 sdk.
sed -i .old 's/FF_ALL_ARCHS_IOS8_SDK="armv7 arm64 i386 x86_64"/FF_ALL_ARCHS_IOS8_SDK="arm64 i386 x86_64"/g' ./compile-ffmpeg.sh
sh ./compile-ffmpeg.sh clean

echo "\x1B[1;34m Building ffmpeg... \x1B[0m"
sh ./compile-ffmpeg.sh all

if [ $? -ne 0 ]; then

    echo "\x1B[1;30m **** Failed to building ffmpeg !! \x1B[0m"
    exit 1
fi

echo "\x1B[1;34m Perpare to build open SSL \x1B[0m"
sh ./compile-openssl.sh clean

echo "\x1B[1;34m Building open SSL... \x1B[0m"
sh ./compile-openssl.sh all

# comment 【#           include "armv7/avconfig.h"】 in avconfig.h
ORLAGAL_INCLUDE='#           include \"armv7\/avconfig.h\"'
REPLACED_INCLUDE='\/\/ #           include \"armv7\/avconfig.h\"'
sed -i .old 's/${ORLAGAL_INCLUDE}/${REPLACED_INCLUDE}/g' ../build/universal/include/libavutil/avconfig.h

# comment 【#           include "armv7/config.h"】 in config.h
ORLAGAL_INCLUDE='#           include \"armv7\/config.h\"'
REPLACED_INCLUDE='\/\/ #           include \"armv7\/config.h\"'
sed -i .old 's/${ORLAGAL_INCLUDE}/${REPLACED_INCLUDE}/g' ../build/universal/include/libffmpeg/config.h

echo "\x1B[1;34m Building framework... \x1B[0m"
cp "${CURRENT_PATH}"/buildFramework.sh ./IJKMediaPlayer/buildFramework.sh
cd ./IJKMediaPlayer
sh buildFramework.sh


# echo "\x1B[1;34m \x1B[0m"