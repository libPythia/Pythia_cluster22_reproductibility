#!/bin/bash

DIRNAME=$(realpath $(dirname $0))


PYTHIA_PREFIX="$DIRNAME/../../install"
APP_DIR="$DIRNAME"
PB_SIZE=small
APP="amg lulesh kripke minife quicksilver bt cg ep ft is lu mg sp"


MPI_CMD=mpirun
MPI_ARGS=""

usage()
{
cat << EOF
usage: $0 options

OPTIONS:
   -h                               Show this message
   -p <director>		    Path to Pythia installation directory
   -b <director>		    Path to applications build directory
   -s <pb_size>			    Problem size (small, medium, large)
   -a <application>		    Run a specific application
EOF
}
while getopts 'p:s:a:h' OPTION; do
  case $OPTION in
  p)
	PYTHIA_PREFIX=$(realpath $OPTARG)
	;;
  b)
	APP_DIR=$(realpath $OPTARG)
	;;
  s)
	PB_SIZE=$OPTARG
	;;
  a)
	APP=$OPTARG
	;;
  h)	usage
	exit 2
	;;
  esac
done
# remove the options from the command line
shift $(($OPTIND - 1))


# AMG
function run_amg() {
    echo "Running AMG with problem size $PB_SIZE"
    export OMP_NUM_THREADS=8
    AMG_PATH="$APP_DIR/AMG/test/amg"
    case $PB_SIZE in
	small)
	    AMG_ARGS="-n 100 100 100"
	    ;;
	medium)
	    AMG_ARGS="-n 150 150 150"
	    ;;
	large)
	    AMG_ARGS="-n 200 200 200"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 8 $AMG_PATH $AMG_ARGS"
    "$MPI_CMD" $MPI_ARGS -np 8 "$AMG_PATH" $AMG_ARGS
}

# BT, CG, EP, FT, IS, LU, MG, SP
function run_npb() {
    kernel=$1
    echo "Running NPB $kernel with problem size $PB_SIZE"
    export OMP_NUM_THREADS=1
    NPB_PATH="$APP_DIR/NPB3.3.1/NPB3.3-MPI/bin/$kernel"
    case $PB_SIZE in
	small)
	    NPB_PATH="${NPB_PATH}.A.64"
	    ;;
	medium)
	    NPB_PATH="${NPB_PATH}.B.64"
	    ;;
	large)
	    NPB_PATH="${NPB_PATH}.C.64"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 64 $NPB_PATH"
    "$MPI_CMD" $MPI_ARGS -np 64 "$NPB_PATH"
}

# Kripke
function run_kripke() {
    echo "Running Kripke with problem size $PB_SIZE"
    export OMP_NUM_THREADS=8
    APP_PATH="$APP_DIR/kripke/build/bin/kripke.exe"
    case $PB_SIZE in
	small)
	    APP_ARGS="--procs 2,2,2 --groups 128"
	    ;;
	medium)
	    APP_ARGS="--procs 2,2,2 --groups 512"
	    ;;
	large)
	    APP_ARGS="--procs 2,2,2 --groups 1024"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 8 $APP_PATH $APP_ARGS"
    "$MPI_CMD" $MPI_ARGS -np 8 "$APP_PATH" $APP_ARGS
}


# Lulesh
function run_lulesh() {
    echo "Running Lulesh with problem size $PB_SIZE"
    export OMP_NUM_THREADS=8
    APP_PATH="$APP_DIR/lulesh/lulesh2.0"
    case $PB_SIZE in
	small)
	    APP_ARGS="-s 10"
	    ;;
	medium)
	    APP_ARGS="-s 30"
	    ;;
	large)
	    APP_ARGS="-s 50"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 8 $APP_PATH $APP_ARGS"
    "$MPI_CMD" $MPI_ARGS -np 8 "$APP_PATH" $APP_ARGS
}


# miniFE
function run_minife() {
    echo "Running miniFE with problem size $PB_SIZE"
    export OMP_NUM_THREADS=8
    APP_PATH="$APP_DIR/miniFE/openmp-opt/src/miniFE.x"
    case $PB_SIZE in
	small)
	    APP_ARGS=" -nx 100 -ny 100 -nz 100"
	    ;;
	medium)
	    APP_ARGS=" -nx 200 -ny 200 -nz 200"
	    ;;
	large)
	    APP_ARGS=" -nx 300 -ny 300 -nz 300"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 8 $APP_PATH $APP_ARGS"
    "$MPI_CMD" $MPI_ARGS -np 8 "$APP_PATH" $APP_ARGS
}

# Quicksilver
function run_quicksilver() {
    echo "Running Quicksilver with problem size $PB_SIZE"
    export OMP_NUM_THREADS=8
    APP_PATH="$APP_DIR/Quicksilver/src/qs"
    case $PB_SIZE in
	small)
	    APP_ARGS="--lx 500 --ly 500 --lz 500 -n 1000000"
	    ;;
	medium)
	    APP_ARGS="--lx 500 --ly 500 --lz 500 -n 10000000"
	    ;;
	large)
	    APP_ARGS="--lx 500 --ly 500 --lz 500 -n 20000000"
	    ;;
	*)
	    echo "invalid problem size"
	    exit 1
    esac

    echo "Running $MPI_CMD $MPI_ARGS -np 8 $APP_PATH $APP_ARGS"
    "$MPI_CMD" $MPI_ARGS -np 8 "$APP_PATH" $APP_ARGS
}


#run_amg
#run_npb bt
#run_kripke
#run_lulesh
#run_minife
#run_quicksilver

for i in $APP ; do
    case $i in
	amg)
	    run_amg
	    ;;
	lulesh)
	    run_lulesh
	    ;;
	kripke)
	    run_kripke
	    ;;
	minife)
	    run_minife
	    ;;
	quicksilver)
	    run_quicksilver
	    ;;
	bt)
	    run_npb bt
	    ;;
	cg)
	    run_npb cg
	    ;;
	ep)
	    run_npb ep
	    ;;
	ft)
	    run_npb ft
	    ;;
	is)
	    run_npb is
	    ;;
	lu)
	    run_npb lu
	    ;;
	mg)
	    run_npb mg
	    ;;
	sp)
	    run_npb sp
	    ;;
	*)
	    echo "Unknown application"
	    exit 1
    esac
done
