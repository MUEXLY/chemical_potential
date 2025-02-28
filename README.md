# chemical_potential

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# About

This repository contains a lightweight LAMMPS interface to calculate chemical potentials for solution solutions of different compositions, and fitting those chemical potentials to a regular solution model. This is particularly useful for calculating thermodynamic driving forces towards equilibrium for solid solutions out of equilibrium.

# Requirements

- [Bash](https://www.gnu.org/software/bash/)
- [Python 3](https://www.python.org/) with [NumPy](https://numpy.org/)
- [LAMMPS](https://www.lammps.org/)

# Calculation

The main portion of this interface is the LAMMPS input file at [in.insertions](https://github.com/muexly/chemical_potential/blob/main/in.insertions). In summary, this input file tells LAMMPS to:

- Read in a lattice, interatomic interactions, and solution information from the user
- Initialize the lattice and minimize at constant pressure
- Loop through all sites (indexed by $\sigma$), place each available atom type (indexed by $\alpha$) at the site, minimize at constant voluem, and store the resulting energy $E_\sigma^{(\alpha)}$.

For details on how this data is used to calculate chemical potentials, see [chemical_potential_calculation.pdf](https://github.com/muexly/chemical_potential/blob/main/chemical_potential_calculation.pdf).

# Example

Most customizability features are accessible through a [JSON](https://en.wikipedia.org/wiki/JSON) configuration file and the bash script [chemical_potentials.sh](https://github.com/muexly/chemical_potential/blob/main/chemical_potentials.sh). An example configuration file is provided in [config.json](https://github.com/muexly/chemical_potential/blob/main/config.json). Run this example with:

```bash
git clone https://github.com/muexly/chemical_potential.git
chmod 755 chemical_potentials.sh
./chemical_potentials.sh config.json
```

This will output a file with information about free energy fitting at [example/output/fit.txt](https://github.com/muexly/chemical_potential/blob/main/example/output/fit.txt), which looks like:

```
RMSE: 0.0007686195179619156
PCC: 0.999801
x_1 x_2 x_3 x_4 x_5 x_1x_2 x_1x_3 x_1x_4 x_1x_5 x_2x_3 x_2x_4 x_2x_5 x_3x_4 x_3x_5 x_4x_5
[-4.33727796 -4.4035419  -3.73086804 -4.10044721 -2.8015742  -0.13807349
 -0.40468946 -0.52796929 -0.44899191 -0.37090297 -0.51128121 -0.60500817
 -0.30052369 -0.69471919 -0.36634538]
```

which corresponds to a fit of $\mu_1 = -4.33727796 -0.13807349x_2 -0.40468946x_3 -0.52796929x_4 -0.44899191x_5$, and so on. Here, the high PCC and low RMSE denote an excellent fit.

For a tutorial on writing your own configuration file, see the documentation at [docs/doc.md](https://github.com/muexly/chemical_potential/blob/main/docs/doc.md).

This codebase heavily builds off of the chemical potential calculation in [our work on vacancy concentration](https://arxiv.org/abs/2402.07324). If you use any code in this repository, please cite that work as well as the repository itself:

```bibtex
@misc{jeffries_chemical_potential_bulk,
    author={Jacob Jeffries},
    title={Bulk Chemical Potential Calculator},
    howpublished={\url{https://github.com/muexly/chemical_potential}},
    year={2024}
}
```

# Acknowledgements

The  work  was  supported  by  the  grant  DE-SC0022980 funded by the U.S. Department of Energy,  Office of Science.