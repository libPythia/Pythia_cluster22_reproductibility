#!/bin/bash

BASE_DIR=$PWD
force=n

# install NPB

# install Lulesh
cd "$BASE_DIR"
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
cd "$BASE_DIR"
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

# install Quicksilver

# install AMG


