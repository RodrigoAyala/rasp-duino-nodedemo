#!/bin/bash

echo -e "nodejs_installer.sh - \033[37mNode\033[32m\033[32mJS \033[0minstaller for \033[35mRaspberry Pi\033[0m"
echo -e "========================================================\n"

if [ "$(uname -m)" != "armv6l" ]; then
  echo -e "\033[31mError: \033[0marmv6l architecture not found. (Are you sure that you are running the script on a Raspberry Pi?)\033[0m";
  exit 1;
else
  echo -e "\033[35mRaspberry Pi \033[32mfound! Proceeding...\033[0m"
fi

command -v node >/dev/null 2>&1

if [[ "$?" ==  0 ]]; then
  echo -e "\033[32mNodeJS already exists! Nothing to do\033[0m";
  exit 1;
fi

set -e

DOWNLOADED_FILE="$(mktemp)"
EXTRACT_TMP="$(mktemp -d)"
NODE_TMPDIR="$EXTRACT_TMP/node-v0.10.1-linux-arm-pi"

echo -e "* \033[35mDownloading NodeJS...\033[0m"
wget http://nodejs.org/dist/v0.10.1/node-v0.10.1-linux-arm-pi.tar.gz -O $DOWNLOADED_FILE

echo -e "* \033[35mExtracting...\033[0m"
tar xfz $DOWNLOADED_FILE -C $EXTRACT_TMP

echo -e "* \033[35mCopying files to /usr/local/ ...\033[0m"

sudo cp -R $NODE_TMPDIR/lib/dtrace /usr/local/lib/
sudo cp -R $NODE_TMPDIR/lib/node_modules /usr/local/lib/
sudo cp -R $NODE_TMPDIR/share/man /usr/local/share/
sudo cp -R $NODE_TMPDIR/bin /usr/local/

echo -e "* \033[35mCleaning everything ...\033[0m"
rm -f $DOWNLOADED_FILE
rm -Rf $EXTRACT_TMP

command -v node >/dev/null 2>&1

if [[ "$?" ==  0 ]]; then
  echo -e "\n \033[32mWe are done! Enjoy NodeJS!\033[0m"
else
  echo -e "\n \033[31mError: Something went wrong, please try again or notify the author."
fi