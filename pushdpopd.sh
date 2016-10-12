#! /bin/bash

#put these in your .bash_profile
#DIR_STACK=""
#export DIR_STACK


# Since I didn't have a lot of time to make this code pretty and I just wanted it to work, I finicked a bit with the functions. I didn't have a working popd function until I added a space to DIR_STACK=${DIR_STACK#*' '} I also had some errors which I just redirected to /dev/null, though the functions appear to be working somewhat properly, though there are some issues :).

function pushd 
{
      dirname=$1
      DIR_STACK="$dirname ${DIR_STACK:-$PWD' '}"
      cd ${dirname:?"missing directory name."}
      echo "PUSHD -> $DIR_STACK"
}

pushd ~
pushd ~

function popd
{
      DIR_STACK=${DIR_STACK#*' '}
      cd ${DIR_STACK%% *}
      echo "POPD -> $DIR_STACK"
}

popd 2> /dev/null
popd 2> /dev/null
