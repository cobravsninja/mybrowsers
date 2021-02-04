#!/bin/bash

ROOT_DIR=$(dirname $0)
[ -z $1 ] && { echo "pls run as $0 container"; exit 1; }
[ ! -d "$ROOT_DIR/$1" ] && {
  echo "$1 directory doesnt exist"
  exit 1
}
docker stop $1

set -e
BIN_DIR=$ROOT_DIR/bin
cd $ROOT_DIR/download
BZ2_URL=`curl -f 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' | egrep -o 'https:\/\/.+\.bz2'`
BZ2_FILE=`echo $BZ2_URL | egrep -o 'firefox-.+\.bz2'`
[ -f $BZ2_FILE ] && {
  echo "latest version already downloaded"
  docker start $1
  exit
}
echo "deleting old versions"
rm -rf *.bz2 2> /dev/null
rm -rf $ROOT_DIR/bin 2> /dev/null
mkdir $BIN_DIR

curl $BZ2_URL > $BZ2_FILE
tar xjvf $BZ2_FILE -C $BIN_DIR
docker start $1
