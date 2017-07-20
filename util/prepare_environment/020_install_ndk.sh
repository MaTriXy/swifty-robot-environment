#### swifty-robot-environment ####
#
# Installs current NDK version and removes unused toolchains and platforms
#
# Version 0.6 (2017-07-19)
#
# Dependencies: ndk @ google/android
#

source .profile

NDK_FILENAME=android-ndk-r14b-linux-x86_64.zip

mkdir ndk

# If the current NDK has been provided in the prefetched directory don't download it again
if [[ -d "./prefetched/" && -f "./prefetched/$NDK_FILENAME" ]];
then
    mv "./prefetched/$NDK_FILENAME" ndk.zip
else
    wget "https://dl.google.com/android/repository/$NDK_FILENAME" -O ndk.zip
fi

unzip ndk.zip -d ./ndk
rm ndk.zip

export NDK=`ls -d -1 ./ndk/* | head -1`

pushd $NDK
    pushd toolchains
        rm -r aarch64-linux-android-4.9 mips64el-linux-android-4.9 mipsel-linux-android-4.9 x86-4.9 x86_64-4.9
    popd

    pushd platforms
        rm -r android-9 android-12 android-13 android-14 android-15 android-17 android-18 android-19 android-22 android-23 android-24
    popd
popd

# Linker binaries for android triple added to an accessible path
ln -s $NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-android-ld.gold
ln -s $NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-ld.gold /usr/bin/armv7-none-linux-androideabi-ld.gold

echo 'export NDK="'`realpath $NDK`'"' >> .profile
