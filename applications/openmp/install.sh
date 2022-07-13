#!/bin/bash

BASE_DIR=$(realpath $(dirname $0))
force=n

BUILDDIR=$PWD

usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h               Show this message
   -b <directory>   Path to the build directory
   -f 	       	    Force building the applications
EOF
}
while getopts 'b:fh' OPTION; do
  case $OPTION in
  b)
	BUILDDIR=$(realpath $OPTARG)
	;;
  f)
      force=y
      ;;
  h)	usage
	exit 2
	;;
  esac
done
# remove the options from the command line
shift $(($OPTIND - 1))


mkdir -p "$BUILDDIR" 2>/dev/null

# install Lulesh
cd "$BUILDDIR"
dir=lulesh
REPO="https://github.com/LLNL/LULESH.git"


if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    git clone "$REPO" $dir || exit 1
    cd $dir || exit 1
    patch -p1 < "$BASE_DIR/patch_lulesh.diff"
    cmake . -DWITH_MPI=OFF -DWITH_OPENMP=ON -DCMAKE_BUILD_TYPE=Release || exit 1
    make || exit 1
fi
