#!/bin/bash

PREFIX=$PWD
BUILDDIR=$PWD
DIRNAME=$(realpath $(dirname $0))

GCC_URL="git://gcc.gnu.org/git/gcc.git"
COMMIT_HASH=5459fa132a99e6037e5ccf1b49d617677a584ff8
FORCE=n


usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h                               Show this message
   -p <director>		    Path to the installation directory
   -b <directory>	       	    Path to the build directory
   -f 				    Force installation
EOF
}
while getopts 'p:b:hf' OPTION; do
  case $OPTION in
  p)
	PREFIX=$OPTARG
	;;
  b)
	BUILDDIR=$OPTARG
	;;
  f)
      FORCE=y
      ;;
  h)	usage
	exit 2
	;;
  esac
done

# remove the options from the command line
shift $(($OPTIND - 1))

# get gcc
mkdir -p "$BUILDDIR" 2>/dev/null
cd "$BUILDDIR"
if [ -d "gcc" ] && [ "$FORCE" = "y" ]; then
    rm -rf "gcc"
fi

if ! [ -d "gcc" ]; then
    git clone $GCC_URL gcc || exit 1
    cd gcc || exit 1 
    git reset --hard $COMMIT_HASH || exit 1

    # apply the patch with our modification
    patch -p1 < "$DIRNAME/patch_gomp.diff" || exit 1

    # build libgomp
    rm -rf build 2>/dev/null
    mkdir build  || exit 1 
    cd build || exit 1
    ../configure --prefix=$PREFIX --disable-multilib
    make -j 180 || exit 1
    make install || exit 1
fi

