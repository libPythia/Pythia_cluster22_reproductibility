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

# install NPB
cd "$BUILDDIR"
dir=NPB3.3.1


if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    wget https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz  || exit 1
    tar xf NPB3.3.1.tar.gz || exit 1
    cd NPB3.3.1/NPB3.3-MPI/ || exit 1
    cp "$BASE_DIR/npb_make.def" config/make.def || exit 1
    cp "$BASE_DIR/npb_suite.def" config/suite.def || exit 1
    make suite || exit 1
fi

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
    cmake . -DWITH_MPI=ON -DCMAKE_BUILD_TYPE=Release || exit 1
    make || exit 1
fi

# install Kripke
cd "$BUILDDIR"
dir=kripke
REPO="https://github.com/LLNL/Kripke.git" 


if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    git clone "$REPO" $dir || exit 1
    cd "$dir" || exit 1
    git submodule update --init --recursive || exit 1

    mkdir build || exit 1
    cd build || exit 1
    
    echo cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_MPI=ON -DENABLE_OPENMP=ON || exit 1
    cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_MPI=ON -DENABLE_OPENMP=ON || exit 1
    make || exit 1
fi


# install miniFE
cd "$BUILDDIR"
dir=miniFE
REPO="https://github.com/Mantevo/miniFE"

if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    git clone "$REPO" $dir || exit 1
    cd $dir/openmp-opt/src || exit 1
    make || exit 1
fi


# install Quicksilver
cd "$BUILDDIR"
dir=Quicksilver
REPO="https://github.com/LLNL/Quicksilver.git"


if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    git clone "$REPO" $dir || exit 1
    cd $dir/src || exit 1
    cp "$BASE_DIR/quicksilver_makefile" "Makefile" || exit 1
    make || exit 1
fi


# install AMG
cd "$BUILDDIR"
dir=AMG
REPO="https://github.com/LLNL/AMG.git"

if [ -d "$dir" ] && [ "$force" = y ]; then
    rm -rf "$dir"
fi

if [ ! -d "$dir" ]; then
    git clone "$REPO" $dir || exit 1
    cd $dir || exit 1
    make || exit 1
fi
