#!/bin/bash

PREFIX=$PWD
BUILDDIR=$PWD

PYTHIA_MPI_URL="https://github.com/libPythia/pythia_mpi.git"
COMMIT_HASH=3b2b1cff76db54c270b23223c3a67eb523bdf771
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


# get the source code
mkdir -p "$BUILDDIR" 2>/dev/null
cd "$BUILDDIR"
if [ -d "pythia_mpi" ] && [ "$FORCE" = "y" ]; then
    rm -rf "pythia_mpi"
fi

if ! [ -d "pythia_mpi" ]; then
    git clone $PYTHIA_MPI_URL pythia_mpi || exit 1
    cd pythia_mpi || exit 1
    git reset --hard $COMMIT_HASH ||exit 1 

    # build mpi-interceptor
    rm -rf build 2> /dev/null
    mkdir  build || exit 1
    cd build || exit 1
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$PREFIX" -DENABLE_MPI=ON || exit 1
    make install || exit 1
fi
