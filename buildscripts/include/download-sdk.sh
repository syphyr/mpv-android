#!/bin/bash -e

. ./include/depinfo.sh

. ./include/path.sh # load $os var

[ -z "$IN_CI" ] && IN_CI=0 # skip steps not required for CI?
[ -z "$WGET" ] && WGET=wget # possibility of calling wget differently

if [ "$os" == "linux" ]; then
	if [ $IN_CI -eq 0 ]; then
		if hash yum &>/dev/null; then
			sudo yum install autoconf pkgconfig libtool ninja-build \
				unzip wget meson python3
			python3 -m pip install --upgrade --user meson
			python3 -m pip install --upgrade --user ninja
			python3 -m pip install --upgrade --user cmake
		elif apt-get -v &>/dev/null; then
			dpkg -l autoconf | grep "^ii" &>/dev/null || { sudo apt-get install autoconf; }
			dpkg -l pkg-config | grep "^ii" &>/dev/null || { sudo apt-get install pkg-config; }
			dpkg -l libtool | grep "^ii" &>/dev/null || { sudo apt-get install libtool; }
			dpkg -l ninja-build | grep "^ii" &>/dev/null || { sudo apt-get install ninja-build; }
			dpkg -l unzip | grep "^ii" &>/dev/null || { sudo apt-get install unzip; }
			dpkg -l wget | grep "^ii" &>/dev/null || { sudo apt-get install wget; }
			dpkg -l meson | grep "^ii" &>/dev/null || { sudo apt-get install meson; }
			dpkg -l python3 | grep "^ii" &>/dev/null || { sudo apt-get install python3; }
			python3 -m pip show meson | grep WARNING &>/dev/null && { python3 -m pip install --upgrade --user meson; }
			python3 -m pip show ninja | grep WARNING &>/dev/null && { python3 -m pip install --upgrade --user ninja; }
			python3 -m pip show cmake | grep WARNING &>/dev/null && { python3 -m pip install --upgrade --user cmake; }
		else
			echo "Note: dependencies were not installed, you have to do that manually."
		fi
	fi

	if ! javac -version &>/dev/null; then
		echo "Error: missing Java Development Kit."
		hash yum &>/dev/null && \
			echo "Install it using e.g. sudo yum install java-latest-openjdk-devel"
		apt-get -v &>/dev/null && \
			echo "Install it using e.g. sudo apt-get install default-jre-headless"
		exit 255
	fi

	os_ndk="linux"
elif [ "$os" == "mac" ]; then
	if [ $IN_CI -eq 0 ]; then
		if ! hash brew 2>/dev/null; then
			echo "Error: brew not found. You need to install Homebrew: https://brew.sh/"
			exit 255
		fi
		brew install \
			automake autoconf libtool pkg-config \
			coreutils gnu-sed wget meson ninja python
	fi
	if ! javac -version &>/dev/null; then
		echo "Error: missing Java Development Kit. Install it manually."
		exit 255
	fi

	os_ndk="darwin"
fi

mkdir -p sdk && cd sdk

if [ -n "${ANDROID_SDK_ROOT_OLD}" ]; then
	if [ ! -d "android-sdk-${os}" ]; then
		echo "Using Android SDK defined by ANDROID_SDK_ROOT"
		ln -s "${ANDROID_SDK_ROOT_OLD}" "android-sdk-${os}"
	fi
fi

# Android SDK
if [ ! -d "android-sdk-${os}" ]; then
	echo "Android SDK (${v_sdk}) not found. Downloading commandline tools."
	$WGET -q --show-progress "https://dl.google.com/android/repository/commandlinetools-${os}-${v_sdk}.zip"
	mkdir "android-sdk-${os}"
	unzip -q -d "android-sdk-${os}" "commandlinetools-${os}-${v_sdk}.zip"
	rm "commandlinetools-${os}-${v_sdk}.zip"
fi
sdkmanager () {
	local exe="./android-sdk-$os/cmdline-tools/latest/bin/sdkmanager"
	[ -x "$exe" ] || exe="./android-sdk-$os/cmdline-tools/bin/sdkmanager"
	"$exe" --sdk_root="${ANDROID_HOME}" "$@"
}
echo y | sdkmanager \
	"platforms;android-${v_sdk_platform}" "build-tools;${v_sdk_build_tools}" \
	"extras;android;m2repository"

# Android NDK (either standalone or installed by SDK)
if [ -d "android-ndk-${v_ndk}" ]; then
	echo "Android NDK (${v_ndk}) directory found."
elif [ -d "android-sdk-$os/ndk/${v_ndk_n}" ]; then
	echo "Creating NDK (${v_ndk_n}) symlink to SDK."
	ln -s "android-sdk-$os/ndk/${v_ndk_n}" "android-ndk-${v_ndk}"
elif [ -d "android-sdk-${os}" ] && [ ! -d "android-sdk-$os/ndk/${v_ndk_n}" ]; then
	echo "Downloading NDK (${v_ndk_n}) with sdkmanager."
	echo y | sdkmanager "ndk;${v_ndk_n}"
	ln -s "android-sdk-$os/ndk/${v_ndk_n}" "android-ndk-${v_ndk}"
elif [ "${os_ndk}" == "linux" ]; then
	echo "Downloading NDK (${v_ndk}) for linux."
	$WGET -q --show-progress "http://dl.google.com/android/repository/android-ndk-${v_ndk}-${os_ndk}.zip"
	unzip -q "android-ndk-${v_ndk}-${os_ndk}.zip"
	rm "android-ndk-${v_ndk}-${os_ndk}.zip"
elif [ "${os_ndk}" == "darwin" ]; then
	echo "Downloading NDK (${v_ndk}) for darwin."
	$WGET -q --show-progress "http://dl.google.com/android/repository/android-ndk-${v_ndk}-${os_ndk}.dmg"
	echo "NDK for darwin requires manual installation."
	exit 255
fi
if ! grep -qF "${v_ndk_n}" "android-ndk-${v_ndk}/source.properties"; then
	echo "Error: NDK exists but is not the correct version (expecting ${v_ndk_n})"
	exit 255
fi

# gas-preprocessor
if [ -f bin/gas-preprocessor.pl ]; then
	echo "Updating existing copy of gas-preprocessor.pl"
else
	echo "Downloading new copy gas-preprocessor.pl"
	mkdir -p bin
fi
$WGET -q --show-progress "https://github.com/FFmpeg/gas-preprocessor/raw/master/gas-preprocessor.pl" \
	-O bin/gas-preprocessor.pl
chmod +x bin/gas-preprocessor.pl

cd ..
