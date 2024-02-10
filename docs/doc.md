# The config file

The input configuration file defines necessary variables to run both LAMMPS and the associated analysis script to post-process the data output from LAMMPS. There are a couple of different subdictionaries in the config file.

### Launch options

The first subdictionary is ``launch_options``, which defines some basic launch options for LAMMPS. The following subdictionary defines a list of arguments to pass into ``mpirun`` (``"mpi_args"``), a dictionary of environment variables (``"env_vars"``), the number of MPI processes (``"np"``), the name of the LAMMPS executable (``"exec"``), extra options to pass into LAMMPS (``"lmp_options"``), and where to write the LAMMPS log file to (``"log_file"``). The default in [config.json](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/config.json) is:

```json
"launch_options": {
    "mpi_args": [
    ],
    "env_vars": {
        "OMP_NUM_THREADS": 1
    },
    "np": 32,
    "exec": "../software/lammps/lammps-2Aug2023/build/lmp",
    "lmp_options": "",
    "log_file": "example/log.lammps"
}
```

which specifies that we want to launch the LAMMPS executable at ``../software/lammps/lammps-2Aug2023/build/lmp`` with no MPI args nor extra LAMMPS options, an environmental variable ``OMP_NUM_THREADS`` set to ``1``, ``32`` processors, and store the resulting log file at ``example/log.lammps``. Example LAMMPS options might be, for example, if you want to run with the ``gpu`` suffix, then you could pass ``"lmp_options": "-sf gpu"``.

### Lattice

The second subdictionary is ``"lattice"``, which defines the lattice-related commands to pass into the LAMMPS input file. This defines the ``lattice`` and ``region`` commands to pass, and a temporary file where these lines will be stored. The default in [config.json](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/config.json) is:

```json
"lattice": {
    "lattice": "fcc 3.0 orient x 1 0 0 orient y 0 1 0 orient z 0 0 1",
    "region": "box block 0 5 0 5 0 5",
    "file": "temps/lattice.txt"
}
```

which will create a text file with the following lines at ``temps/lattice.txt``:

```
lattice fcc 3.0 orient x 1 0 0 orient y 0 1 0 orient z 0 0 1
region box block 0 5 0 5 0 5
```

and load that file into the LAMMPS input file.

### Solution

The third subdictionary is ``"solution"``, which defines the concentrations to create and run simulations for. The key ``"ntypes"`` defines the number of types in the solution, the key ``"concentrations"`` defines the desired concentrations of each element, and the key ``"file"`` defines where to store these concentrations. The script will loop through all possible combinations of concentrations that you give and perform calculations for valid compositions (i.e. if the sum of concentrations is 1). The default in [config.json](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/config.json) is:

```json
"solution": {
    "ntypes": 5,
    "concentrations": [
        [0.15, 0.20, 0.25],
        [0.15, 0.20, 0.25],
        [0.15, 0.20, 0.25],
        [0.15, 0.20, 0.25],
        [0.15, 0.20, 0.25]
    ],
    "file": "temps/solutions.txt"
}
```

which creates a solution with ``5`` types, specifies that you want to create solutions with compositions with atomic fractions of ``0.15``, ``0.20``, and ``0.25`` for each element, and stores the valid compositions in ``temps/solutions.txt``.

### Interactions

The fourth subdictionary defines the interatomic interactions. This defines the ``pair_style`` and ``pair_coeff`` lines to pass, and a temporary file where the lines will be stored. The default in [config.json](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/config.json) is:

```json
"interactions": {
    "pair_style": "meam",
    "pair_coeff": "* * example/library.meam Co Ni Cr Fe Mn example/CoNiCrFeMn.meam Co Ni Cr Fe Mn",
    "file": "temps/interactions.txt"
}
```

which will write a text file with the following lines at ``temps/interactions.txt``:

```
pair_style meam
pair_coeff * * example/library.meam Co Ni Cr Fe Mn example/CoNiCrFeMn.meam Co Ni Cr Fe Mn
```

and load that file into the LAMMPS input file.

### Extra Variables

The fifth subdictionary defines some extra variables to be used by LAMMPS. The key ``"units"`` defines what units to use in the simulations, and every other key defines parameters used to minimize configurations.

### Outputs

The last subdictionary defines where to store output information. The key ``"relaxed_data"`` stores the LAMMPS data file for the initially relaxed configuration, the key ``"occupying_energies"`` defines where to store the occupying energies, the key ``"chemical_potentials"`` defines where to store a table of chemical potentials and compositions, and the key ``"fit"`` defines where to store information about the fit.

Note that the relaxed data and occupying energies files will be overwritten when a new simulation with a different composition is ran.