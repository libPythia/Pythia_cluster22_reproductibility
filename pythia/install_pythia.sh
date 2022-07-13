#!/bin/bash

PREFIX=$PWD
BUILDDIR=$PWD
PYTHIA_URL="https://github.com/libPythia/pythia.git"
COMMIT_HASH=f353a754bcc1fe6c525a14f81ae3c4faf9967856


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
	PREFIX=$OPTARG
	;;
  b)
	BUILDDIR=$OPTARG
	;;
  h)	usage
	exit 2
	;;
  esac
done

# remove the options from the command line
shift $(($OPTIND - 1))

# get Pythia
mkdir -p "$BUILDDIR" 2>/dev/null
cd "$BUILDDIR"
if [ -d "pythia" ]; then
    rm -rf "pythia"
fi
git clone "$PYTHIA_URL" pythia || exit 1
cd pythia || exit 1
git reset --hard $COMMIT_HASH || exit 1

# install pythia
meson build -Dprefix="$PREFIX" || exit 1
cd build || exit 1
ninja install || exit 1

