#!/bin/bash

PREFIX=$PWD/install
BUILDDIR=$PWD/build

DIRNAME=$(realpath $(dirname $0))
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
	PREFIX=$(realpath $OPTARG)
	;;
  b)
	BUILDDIR=$(realpath $OPTARG)
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


COMMON_OPTIONS=""
if [ "$FORCE" = "y" ]; then
    COMMON_OPTIONS="$OPTIONS -f"
fi

# install Pythia
"$DIRNAME/pythia/install_pythia.sh" -b "$BUILDDIR" -p "$PREFIX" $COMMON_OPTIONS || exit 1

OLDPATH=$PATH;
export PATH="$PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/x86_64-linux-gnu/pkgconfig/:$PKG_CONFIG_PATH"
export CFLAGS="-I$PREFIX/include $CFLAGS"
export CXXFLAGS="-I$PREFIX/include $CXXFLAGS"
export LDFLAGS="-L$PREFIX/lib/x86_64-linux-gnu/ $LDFLAGS"

# Install runtime systems

## install pythia_mpi
"$DIRNAME/runtimes/mpi/install.sh" -b "$BUILDDIR" -p "$PREFIX" $COMMON_OPTIONS || exit 1

## install GNU OpenMP
"$DIRNAME/runtimes/gnu_openmp/install.sh" -b "$BUILDDIR" -p "$PREFIX" $COMMON_OPTIONS || exit 1



# Compile applications
PATH=$OLDPATH #restore the old PATH to prevent applications from being compiled with our gcc/g++
"$DIRNAME/applications/mpi/install.sh" -b "$DIRNAME/applications/mpi" $COMMON_OPTIONS || exit 1
"$DIRNAME/applications/openmp/install.sh" -b "$DIRNAME/applications/openmp" $COMMON_OPTIONS || exit 1
