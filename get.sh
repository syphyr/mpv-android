echo "Updating mpv-android"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase

cd buildscripts/deps/dav1d
echo "Updating dav1d"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase

#cd ../elf-cleaner
#echo "Updating elf-cleaner"
#git fetch
#git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
#git rebase

cd ../ffmpeg
echo "Updating ffmpeg"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase

#cd ../freetype2
#echo "Updating freetype2"
#git fetch
#git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
#git rebase
#git submodule update --init --recursive --rebase

cd ../libass
echo "Updating libass"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase

cd ../libplacebo
echo "Updating libplacebo"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase
git submodule update --init --recursive --rebase

cd ../google-shaderc
echo "Updating google-shaderc"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/main
git rebase
cd utils
./git-sync-deps
cd ..

cd ../mpv
echo "Updating mpv"
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/master
git rebase
