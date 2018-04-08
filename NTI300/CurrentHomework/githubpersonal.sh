#!/bin/bash

sudo yum -y install git

git clone https://github.com/nic-instruction/NTI-300/
echo "a clone of the NTI-300 reposatory is now sitting in this dir"

git config --global user.name "codycodes"
echo "***username configured***"

git config --global user.email codygagnon@gmail.com
echo "***email configured***"

git config --global color.ui auto
echo "helpful colors enabled"

git pull https://github.com/codycodes/Linux-Private-Code
echo "Cody's personal repository was pulled to this dir"
