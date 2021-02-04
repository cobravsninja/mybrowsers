#!/bin/bash

# https://github.com/scheib/chromium-latest-linux

ROOT_DIR=$(dirname $0)
[ -z $1 ] && { echo "pls run as $0 container"; exit 1; }
[ ! -d "$ROOT_DIR/$1" ] && {
  echo "$1 directory doesnt exist"
  exit
}
docker stop $1

set -e
BIN_DIR=$ROOT_DIR/bin
cd $ROOT_DIR/download
LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"
REVISION=$(curl -s -S $LASTCHANGE_URL)
echo "latest revision is $REVISION"
ZIP_FILE="${REVISION}-chrome-linux.zip"

[ -f $ZIP_FILE ] && {
  echo "latest version already downloaded"
  docker start $1
  exit
}

echo "deleting old versions"
read -p "Are you sure? " -n 1 -r
echo 
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  docker start $1
  exit 1
fi
rm -rf *.zip 2> /dev/null
rm -rf $ROOT_DIR/bin 2> /dev/null
mkdir $BIN_DIR

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
echo "fetching $ZIP_URL"
curl $ZIP_URL > $ZIP_FILE
unzip $ZIP_FILE -d $BIN_DIR

docker start $1
