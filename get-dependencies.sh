#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    nodejs   \
    node-gyp \
    npm      \
    yarn

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Getting app..."
echo "---------------------------------------------------------------"
git clone https://github.com/durasj/webamp-desktop.git

mkdir -p ./AppDir/bin
cd webamp-desktop

sed -i \
  -e 's|const { width, height } = screen.getPrimaryDisplay().workAreaSize;|// & \n  const width = 1200;\n  const height = 800;|' \
  -e 's/resizable: false/resizable: true/g' \
  -e 's/movable: false/movable: true/g' \
  -e 's/setIgnoreMouseEvents(true, { forward: true })/setIgnoreMouseEvents(false, { forward: false })/g' \
  main.js

yarn install
npx electron-builder -l --x64
mv -v artifacts/linux-unpacked/* ../AppDir/bin
