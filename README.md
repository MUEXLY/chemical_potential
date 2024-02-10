# chemical_potential_bulk

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# About

This repository contains a lightweight LAMMPS interface to calculate chemical potentials for solution solutions of different compositions, and fitting those chemical potentials to a regular solution model. This is particularly useful for calculating thermodynamic driving forces towards equilibrium for solid solutions out of equilibrium.

# Requirements

- [Bash](https://www.gnu.org/software/bash/)
- [Python 3](https://www.python.org/) with [NumPy](https://numpy.org/)
- [R](https://www.r-project.org/)
- [LAMMPS](https://www.lammps.org/)

# Calculation

The main portion of this interface is the LAMMPS input file at [in.insertions](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/in.insertions). In summary, this input file tells LAMMPS to:

- Read in a lattice, interatomic interactions, and solution information from the user
- Initialize the lattice and minimize at constant pressure
- Loop through all sites (indexed by $\sigma$), place each available atom type (indexed by $\alpha$) at the site, minimize at constant voluem, and store the resulting energy $E_\sigma^{(\alpha)}$.

For details on how this data is used to calculate chemical potentials, see [chemical_potential_calculation.pdf](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/chemical_potential_calculation.pdf).

# Example

Most customizability features are accessible through a [JSON](https://en.wikipedia.org/wiki/JSON) configuration file and the bash script [chemical_potentials.sh](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/chemical_potentials.sh). An example configuration file is provided in [config.json](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/config.json). Run this example with:

```bash
git clone https://github.com/jwjeffr/chemical_potential_bulk.git
chmod 755 chemical_potentials.sh
./chemical_potentials.sh config.json
```

This will output a file with information about chemical potential fitting at [example/output/fit.txt](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/example/output/fit.txt):

```

```

There is a row of ``NA``s because there are only 4 independent compositional variables for a 5 element solution (since the sum of concentrations has to be exactly ``1``). Each column defines a set of coefficients, including the intercept $\mu_\alpha^\circ$ and fitting parameters $A_{\alpha\beta}$, which are defined in [chemical_potential_calculation.pdf](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/chemical_potential_calculation.pdf).

For a tutorial on writing your own configuration file, see the documentation at [docs/doc.md](https://github.com/jwjeffr/chemical_potential_bulk/blob/main/docs/doc.md).

# Acknowledgements

The  work  was  supported  by  the  grant  DE-SC0022980 funded by the U.S. Department of Energy,  Office of Science.