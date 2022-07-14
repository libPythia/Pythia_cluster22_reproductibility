# Pythia_cluster22_reproductibility


This repo contains details to reproduce the results presented in the
paper "PYTHIA : an oracle to guide runtime system decisions",
published at Cluster 2022


## Content

The repo is organized as follows:
- [pythia](pythia) contains the script for installing the `pythia` library
- [runtimes](runtimes) contains the source code of the two runtime systems described in the paper
- [applications](applications) contains the source code of the applications used in the paper

## Building Pythia and its runtime systems

Before building, you may need to install a few dependencies.  This can
be done by running `install_dependencies.sh` that recursively calls
the `install_dependencies.sh` scripts in the `pythia` or `runtimes`
directories. You may also install the dependencies manually


To install `pythia` and its runtime systems, simply run the `install.sh` script. This will compile/install:
- pythia: the oracle library
- pythia_mpi: the MPI runtime system that uses Pythia
- gcc: the GNU OpenMP runtime system that uses Pythia
- applications: all the MPI/MPI+OpenMP applications used in the paper evaluation, as well as the modified OpenMP version of Lulesh

## Running the applications

The `applications` directory contains a script named
`run_applications.sh`. This script runs the selected application with
various problem sizes. Several options control whether Pythia-record
or Pythia-predict is enabled.

For example in `applications/openmp`:

```
[applications/openmp]$ ./run_applications.sh -s 10     # Run lulesh with problem size 10. Pythia is disabled
Running Lulesh with problem size 10
Eta oracle is disabled
[...]


[applications/openmp]$ ./run_applications.sh -s 10 -r   # Run lulesh with problem size 10. Pythia-record is enabled
Running Lulesh with problem size 10
Eta oracle recording
[...]

[applications/openmp]$ ./run_applications.sh -s 10 -P    # Run lulesh with problem size 10. Pythia-predict is enabled
Running Lulesh with problem size 10
Use 4 threads for parallel region taking more than 0.000001s
Use 8 threads for parallel region taking more than 0.000030s
Use 16 threads for parallel region taking more than 0.000600s

```


Other examples in `applications/mpi`:

```
[applications/mpi$] ./run_applications.sh -a amg -s small  # Run AMG with problem size small. Pythia is disabled
[...]

[applications/mpi$] ./run_applications.sh -a amg -s small -r  # Run AMG with problem size small. Pythia-record is enabled
[...]

[applications/mpi$] ./run_applications.sh -a amg -s small -P  # Run AMG with problem size small. Pythia-predict is enabled
[...]

```