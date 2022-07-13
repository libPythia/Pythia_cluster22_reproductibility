#!/bin/bash

PREFIX=$PWD/install
BUILDDIR=$PWD/build

DIRNAME=$(realpath $(dirname $0))

usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h                               Show this message
   -p <director>		    Path to the installation directory
   -b <directory>	       	    Path to the build directory
EOF
}
while getopts 'p:b:h' OPTION; do
  case $OPTION in
  p)
	PREFIX=$(realpath $OPTARG)
	;;
  b)
	BUILDDIR=$(realpath $OPTARG)
	;;
  h)	usage
	exit 2
	;;
  esac
done
# remove the options from the command line
shift $(($OPTIND - 1))


# install Pythia
"$DIRNAME/pythia/install_pythia.sh" -b "$BUILDDIR" -p "$PREFIX"

export PATH="$PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/x86_64-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH"
export CFLAGS="-I$PREFIX/include $CFLAGS"
export CXXFLAGS="-I$PREFIX/include $CXXFLAGS"
export LDFLAGS="-L$PREFIX/lib/x86_64-linux-gnu/ $LDFLAGS"

# Install runtime systems

## install pythia_mpi
"$DIRNAME/runtimes/mpi/install.sh" -b "$BUILDDIR" -p "$PREFIX"

## install GNU OpenMP
"$DIRNAME/runtimes/gnu_openmp/install.sh" -b "$BUILDDIR" -p "$PREFIX"
