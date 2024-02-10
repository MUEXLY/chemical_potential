#!/usr/bin/bash

# load in config file from command line args
config_file_name=$1

# define a shorthand function to grab values from keys in configuration file
cfg () {
	jq -r $1 ${config_file_name}
}

lmp=$(cfg '.launch_options.exec')
np=$(cfg '.launch_options.np')

ntypes=$(cfg '.solution.ntypes')

lattice_file=$(cfg '.lattice.file')

echo "lattice $(cfg '.lattice.lattice')" > ${lattice_file}
echo "region $(cfg '.lattice.region')" >> ${lattice_file}
echo "create_box ${ntypes} box" >> ${lattice_file}
echo "create_atoms 1 box" >> ${lattice_file}

interactions_file=$(cfg '.interactions.file')

echo "pair_style $(cfg '.interactions.pair_style')" > ${interactions_file}
echo "pair_coeff $(cfg '.interactions.pair_coeff')" >> ${interactions_file}

# using cfg() doesn't work here? why?
mpi_args=$(jq -r '.launch_options.mpi_args | join(" ")' ${config_file_name})

# from envvars subdictionary, create a string that bash can read to define those environment variables
envvars_dict=$(cfg '.launch_options.env_vars')
envvars=""
for key in $(echo ${envvars_dict} | jq -r 'keys_unsorted[]')
do
  value=$(echo ${envvars_dict} | jq -r ".${key}")
  envvars+=" ${key}=${value}"
done

options=$(cfg '.launch_options.lmp_options')

occupying_energies_file=$(cfg '.outputs.occupying_energies')

# create string with variables
var_str="-var lattice_file ${lattice_file} \
  -var interactions_file ${interactions_file} \
  -var occupying_energies_file ${occupying_energies_file} \
  -var relaxed_data_file $(cfg '.outputs.relaxed_data') \
  -var ntypes ${ntypes}"

# add extra variables to string
more_vars=("units" "dmax" "pressure" "vmax" "etol" "ftol" "maxsteps")
vars_dict=$(cfg '.extra_vars')
for var in "${more_vars[@]}"
do
  var_str+=" -var ${var} $(echo ${vars_dict} | jq --arg keyvar "$var" '.[$keyvar]')"
done

header=""

for((i=1; i<=$ntypes; i++)) {
  header+="x_${i} "
}
for((i=1; i<=$ntypes; i++)) {
  header+="mu_${i} "
}

chemical_potentials_file=$(cfg '.outputs.chemical_potentials')
echo ${header} > ${chemical_potentials_file}

all_compositions_file=$(cfg '.solution.all_compositions_file')
single_composition_file=$(cfg '.solution.single_composition_file')

# print out possible compositions
python src/get_compositions.py $(cfg '.solution.concentrations') > ${all_compositions_file}
while read p
do
  python src/get_composition_lines.py $p > ${single_composition_file}

  # call LAMMPS
  env ${envvars} mpirun ${mpi_args} -np ${np} ${lmp} ${options} \
    -in in.insertions -echo log -log $(cfg '.launch_options.log_file') \
    -var composition_file ${single_composition_file} ${var_str} > /dev/null < /dev/null
  gzip --force ${occupying_energies_file}

  python src/chemical_potentials.py ${occupying_energies_file}.gz >> ${chemical_potentials_file}
done < ${all_compositions_file}

Rscript src/fit.r ${chemical_potentials_file} > $(cfg '.outputs.fit')
