git clean -fdx -e buildscripts
cd buildscripts
git clean -fdx -e deps -e sdk -e dist.zip

cd deps

if [ -d mbedtls ]; then
	cd mbedtls
	git clean -fdx
	git submodule foreach --recursive git clean -xfd
	git reset --hard
	git submodule foreach --recursive git reset --hard
	cd ..
fi

if [ -d dav1d ]; then
	cd dav1d
	git clean -fdx
	git reset --hard
	cd ..
fi

if [ -d elf-cleaner ]; then
	cd elf-cleaner
	git clean -fdx
	git reset --hard
	cd ..
fi

if [ -d ffmpeg ]; then
	cd ffmpeg
	git clean -fdx
	git reset --hard
	cd ..
fi

if [ -d freetype2 ]; then
	cd freetype2
	git clean -fdx
	git submodule foreach --recursive git clean -xfd
	git reset --hard
	git submodule foreach --recursive git reset --hard
	cd ..
fi

if [ -d libass ]; then
	cd libass
	git clean -fdx
	git reset --hard
	cd ..
fi

if [ -d libplacebo ]; then
	cd libplacebo
	git clean -fdx
	git submodule foreach --recursive git clean -xfd
	git reset --hard
	git submodule foreach --recursive git reset --hard
	cd ..
fi

if [ -d mpv ]; then
	cd mpv
	git clean -fdx
	git reset --hard
	cd ..
fi

git clean -fdx -e mbedtls -e dav1d -e elf-cleaner -e ffmpeg -e freetype2 -e libass -e mpv -e "*.tar.gz" -e "*.tar.xz" -e libplacebo -e google-shaderc
