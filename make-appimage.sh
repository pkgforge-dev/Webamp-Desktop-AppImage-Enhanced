#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=0.3.0
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/durasj/webamp-desktop/refs/heads/master/res/icon.png
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_GTK=1
export GTK_DIR=gtk-3.0

# Deploy dependencies
quick-sharun ./AppDir/bin/webamp-desktop ./AppDir/bin/libffmpeg.so #./AppDir/bin/*
#echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
