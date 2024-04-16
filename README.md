# chemical_potential

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# About

This repository contains a lightweight LAMMPS interface to calculate chemical potentials for solution solutions of different compositions, and fitting those chemical potentials to a regular solution model. This is particularly useful for calculating thermodynamic driving forces towards equilibrium for solid solutions out of equilibrium.

# Requirements

- [Bash](https://www.gnu.org/software/bash/)
- [Python 3](https://www.python.org/) with [NumPy](https://numpy.org/)
- [R](https://www.r-project.org/) with the [car](https://www.rdocumentation.org/packages/car/) and [dplyr](https://www.rdocumentation.org/packages/dplyr/versions/1.0.10) packages
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
RMSE: 0.000596320165332659
TEST FOR CONSTANT VARIANCE
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.887524, Df = 1, p = 0.16948
TEST FOR NORMALLY DISTRIBUTED ERRORS

	Shapiro-Wilk normality test

data:  .
W = 0.9914, p-value = 0.9712

TEST FOR INDEPENDENCE OF ERRORS
 lag Autocorrelation D-W Statistic p-value
   1      -0.0315274      2.035268   0.672
 Alternative hypothesis: rho != 0

COEFFICIENTS
       x_1        x_2        x_3        x_4        x_5    x_1:x_2    x_1:x_3 
-4.3372780 -4.4035419 -3.7308680 -4.1004472 -2.8015742 -0.1380735 -0.4046895 
   x_1:x_4    x_1:x_5    x_2:x_3    x_2:x_4    x_2:x_5    x_3:x_4    x_3:x_5 
-0.5279693 -0.4489919 -0.3709030 -0.5112812 -0.6050082 -0.3005237 -0.6947192 
   x_4:x_5 
-0.3663454 

```

which corresponds to a fit of $\mu_1 = -4.3372780 - 0.1380735x_2 - 0.4046895x_3 - 0.5279693 - 0.4489919$, $\mu_2 = -4.4035419 -0.1380735x_1 -0.3709030x_3 -0.5112812x_4 -0.6050082x_5$, and so on.

Various tests are performed on the fit, namely a constant variance test, a test for normally distributed errors, and a test for independence of errors. In all cases, the P-value should be far from 0. If it isn't, it does not necessarily mean the model is useless for prediction, but should serve as a soft warning. For example, the P-value for the normally distributed error test in the example is small, indicating that the residual plot has a pattern, or equivalently that a nonlinear model would be a better predictor. However, here, the adjusted R-squared is close to $1.0$, indicating an excellent fit.

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