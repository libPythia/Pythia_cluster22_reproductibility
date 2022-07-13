#!/bin/bash

PREFIX=$PWD

GCC_URL="git://gcc.gnu.org/git/gcc.git"
COMMIT_HASH=

# get gcc


git clone $GCC_URL gcc
cd gcc
git reset --hard $COMMIT_HASH

# apply the patch with our modification
patch -p1 ../patch.diff

# build libgomp
# TODO

