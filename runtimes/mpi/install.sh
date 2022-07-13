#!/bin/bash

PREFIX=$PWD

MPI_INTERCEPTOR_URL="TODO"
COMMIT_HASH=

# get MPI_interceptor


git clone $MPI_INTERCEPTOR_URL mpi-interceptor
cd mpi-interceptor
git reset --hard $COMMIT_HASH

# apply the patch with our modification
patch -p1 ../patch.diff

# build mpi-interceptor
# TODO

