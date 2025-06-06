#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$IN_CI" ] && IN_CI=0
[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# mbedtls
if [ ! -d mbedtls ]; then
	git clone --recurse-submodules https://github.com/Mbed-TLS/mbedtls -b v$v_mbedtls
else
	cd mbedtls
	echo "Updating mbedtls"
	git fetch
	git checkout -f v$v_mbedtls
	git describe --tags --always
	git submodule update --init --recursive --rebase
	cd ..
fi

# dav1d
[ ! -d dav1d ] && git clone https://github.com/videolan/dav1d

# ffmpeg
if [ ! -d ffmpeg ]; then
	git clone https://github.com/FFmpeg/FFmpeg ffmpeg
	[ $IN_CI -eq 1 ] && git -C ffmpeg checkout -f $v_ci_ffmpeg
fi

# freetype2
if [ ! -d freetype2 ]; then
	git clone --recurse-submodules https://gitlab.freedesktop.org/freetype/freetype.git freetype2 -b VER-${v_freetype//./-}
else
	cd freetype2
	git fetch
	echo "Updating freetype2"
	git checkout -f VER-${v_freetype//./-}
	git describe --tags --always
	git submodule update --init --recursive --rebase
	cd ..
fi

# fribidi
if [ ! -d fribidi ]; then
	mkdir fribidi
	if [ ! -f fribidi-$v_fribidi.tar.xz ]; then
		$WGET -q --show-progress https://github.com/fribidi/fribidi/releases/download/v$v_fribidi/fribidi-$v_fribidi.tar.xz
	fi
	echo "Extracting fribidi-$v_fribidi.tar.xz"
	tar -xJ -C fribidi --strip-components=1 -f fribidi-$v_fribidi.tar.xz
fi

# harfbuzz
if [ ! -d harfbuzz ]; then
	mkdir harfbuzz
	if [ ! -f harfbuzz-$v_harfbuzz.tar.xz ]; then
		$WGET -q --show-progress https://github.com/harfbuzz/harfbuzz/releases/download/$v_harfbuzz/harfbuzz-$v_harfbuzz.tar.xz
	fi
	echo "Extracting harfbuzz-$v_harfbuzz.tar.xz"
	tar -xJ -C harfbuzz --strip-components=1 -f harfbuzz-$v_harfbuzz.tar.xz
fi

# unibreak
if [ ! -d unibreak ]; then
	mkdir unibreak
	if [ ! -f libunibreak-${v_unibreak}.tar.gz ]; then
		$WGET -q --show-progress https://github.com/adah1972/libunibreak/releases/download/libunibreak_${v_unibreak//./_}/libunibreak-${v_unibreak}.tar.gz
	fi
	echo "Extracting libunibreak-${v_unibreak}.tar.gz"
	tar -xz -C unibreak --strip-components=1 -f libunibreak-${v_unibreak}.tar.gz
fi

# libass
[ ! -d libass ] && git clone https://github.com/libass/libass

# lua
if [ ! -d lua ]; then
	mkdir lua
	if [ ! -f lua-$v_lua.tar.gz ]; then
		$WGET -q --show-progress https://www.lua.org/ftp/lua-$v_lua.tar.gz
	fi
	echo "Extracting lua-$v_lua.tar.gz"
	tar -xz -C lua --strip-components=1 -f lua-$v_lua.tar.gz
fi

# shaderc
mkdir -p shaderc
cat >shaderc/README <<'HEREDOC'
shaderc sources are provided by the NDK
see <ndk>/sources/third_party/shaderc
HEREDOC

# google-shaderc
if [ ! -d google-shaderc ]; then
	git clone --recursive https://github.com/google/shaderc google-shaderc
	cd google-shaderc/utils
	./git-sync-deps
	cd ../..
fi

# libplacebo
[ ! -d libplacebo ] && git clone --recursive https://github.com/haasn/libplacebo

# mpv
[ ! -d mpv ] && git clone https://github.com/mpv-player/mpv

