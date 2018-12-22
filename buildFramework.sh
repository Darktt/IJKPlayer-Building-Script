#!/bin/sh

set -e

IJK_TARGET=$1
IJK_BUILD_DIR="./build"
IJK_FRMAEWORK_DIR="./framework"
IJK_FRMAEWORK_IOS_PATH="${IJK_BUILD_DIR}/Release-iphoneos/${IJK_TARGET}.framework"
IJK_FRMAEWORK_IOS_SIMULATOR_PATH="${IJK_BUILD_DIR}/Release-iphonesimulator/${IJK_TARGET}.framework"

# Xcode building function.
function build_static_library {

	VALID_ARCHS=""
	if [ "${1}" == "iphoneos" ]; then
		VALID_ARCHS="arm64 arm64e armv7s"
	else
		VALID_ARCHS="i386 x86_64"
	fi

	xcrun xcodebuild -project IJKMediaPlayer.xcodeproj \
	-target "${IJK_TARGET}" \
	-configuration Release VALID_ARCHS="$VALID_ARCHS"\
	-sdk "${1}" \
	ONLY_ACTIVE_ARCH=NO
}

# Check has given argument.
if [ "${IJK_TARGET}"!="IJKMediaFramework" ] || [ "${IJK_TARGET}"!="IJKMediaFrameworkWithSSL" ]; then
	echo "Tagret not define, please select target:"
	echo "    1. IJKMediaFramework"
	echo "    2. IJKMediaFrameworkWithSSL"
	read -p "Input a number: " Number

	if [ "${Number}" == "1" ]; then
		IJK_TARGET=IJKMediaFramework
	elif [ "${Number}" == "2" ]; then
		IJK_TARGET=IJKMediaFrameworkWithSSL
	else
		echo "\x1B[1;31mWrong number!!\x1B[0m"
		exit 0
	fi

	# reassiging variable.
	IJK_FRMAEWORK_IOS_PATH="${IJK_BUILD_DIR}/Release-iphoneos/${IJK_TARGET}.framework"
	IJK_FRMAEWORK_IOS_SIMULATOR_PATH="${IJK_BUILD_DIR}/Release-iphonesimulator/${IJK_TARGET}.framework"
fi

echo "\x1B[1;34m ============ \x1B[0m"
echo "\x1B[1;34m = Clean up = \x1B[0m"
echo "\x1B[1;34m ============ \x1B[0m"

#check build is exist, then remove it.
if [ -d "${IJK_BUILD_DIR}" ]; then
	rm -r "${IJK_BUILD_DIR}"
fi

if [ -d "${IJK_FRMAEWORK_DIR}" ]; then
	rm -r "${IJK_FRMAEWORK_DIR}"
fi

# clean up current build files.
xcrun xcodebuild clean

# build iOS and iOS simulator.
for platfrom in iphoneos iphonesimulator
do
	echo "\x1B[1;34m ******** Building ${platfrom} \x1B[0m"
	build_static_library "${platfrom}"
done

echo "\x1B[1;34m ====================== \x1B[0m"
echo "\x1B[1;34m = Creating framework = \x1B[0m"
echo "\x1B[1;34m ====================== \x1B[0m"
echo "\n\n"

# Create folder if not exist.
mkdir -p "${IJK_FRMAEWORK_DIR}"

printf "\033[1A*\n"

# Copy a framework to this folder
cp -r "${IJK_FRMAEWORK_IOS_PATH}" "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}.framework"

printf "\033[1A***\n"

# Merge iOS and iOS simulator frameworks.
lipo -create "${IJK_FRMAEWORK_IOS_PATH}/${IJK_TARGET}" "${IJK_FRMAEWORK_IOS_SIMULATOR_PATH}/${IJK_TARGET}" -o "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}"

printf "\033[1A*****\n"

# Replace file
rm "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}.framework/${IJK_TARGET}"
cp -a "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}" "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}.framework/${IJK_TARGET}"

printf "\033[1A*******\n"

# Copy the framework to the user's desktop
ditto "${IJK_FRMAEWORK_DIR}/${IJK_TARGET}.framework" "${HOME}/Desktop/${IJK_TARGET}.framework"

printf "\033[1ADone   \n"