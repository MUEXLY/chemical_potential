#!/bin/bash

#SBATCH --job-name chem_pot
#SBATCH --nodes 1
#SBATCH --cpus-per-task 8
#SBATCH --mem 10gb
#SBATCH --time 72:00:00

module purge

# Set the environment variable for the installed R library location
export R_LIBS_USER="/home/$USER/R/x86_64-pc-linux-gnu-library/4.4"

# Change the working directory to the submit location
cd $SLURM_SUBMIT_DIR

# Necessary modules required to run the program
modules=(
    r
    anaconda3
    openmpi
    intel-oneapi-mpi
    fftw
)

# lammps slows down drastically if the num of threads is not set to 1
export OMP_NUM_THREADS=1

# load modules
for module in "${modules[@]}"; do
    module add ${module}
done

# run program
./chemical_potentials.sh config.json
