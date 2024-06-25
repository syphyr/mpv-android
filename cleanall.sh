git clean -fdx

cd buildscripts/deps/dav1d
git clean -fdx
git reset --hard

cd ../elf-cleaner
git clean -fdx
git reset --hard

cd ../ffmpeg
git clean -fdx
git reset --hard

cd ../freetype2
git clean -fdx
git reset --hard

cd ../libass
git clean -fdx
git reset --hard

cd ../libplacebo
git clean -fdx
git submodule foreach --recursive git clean -xfd
git reset --hard
git submodule foreach --recursive git reset --hard

cd ../mpv
git clean -fdx
git reset --hard
