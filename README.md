# chemical_potential

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# About

This repository contains a lightweight LAMMPS interface to calculate chemical potentials for solution solutions of different compositions, and fitting those chemical potentials to a regular solution model. This is particularly useful for calculating thermodynamic driving forces towards equilibrium for solid solutions out of equilibrium.

# Requirements

- [Bash](https://www.gnu.org/software/bash/)
- [Python 3](https://www.python.org/) with [NumPy](https://numpy.org/)
- [R](https://www.r-project.org/)
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

This will output a file with information about chemical potential fitting at [example/output/fit.txt](https://github.com/muexly/chemical_potential/blob/main/example/output/fit.txt). Each chemical potential will have a section that looks like:

```
************** FIT FOR mu_1 **************
------------------------------------
TEST FOR CONSTANT VARIANCE
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.2917373, Df = 1, p = 0.58911
------------------------------------
TEST FOR NORMALLY DISTRIBUTED ERRORS

	Shapiro-Wilk normality test

data:  mod$residuals
W = 0.9452, p-value = 0.01995

------------------------------------
TEST FOR INDEPENDENCE OF ERRORS
 lag Autocorrelation D-W Statistic p-value
   1     -0.05215275      1.994041   0.796
 Alternative hypothesis: rho != 0
------------------------------------
MODEL INFORMATION
Call:
lm(formula = formula(eqn), data = chemical_potentials)

Residuals:
       Min         1Q     Median         3Q        Max 
-0.0032784 -0.0011208 -0.0003747  0.0009916  0.0058961 

Coefficients:
             Estimate Std. Error  t value Pr(>|t|)    
(Intercept) -4.379943   0.005581 -784.759  < 2e-16 ***
x_2          0.015071   0.008850    1.703   0.0953 .  
x_3          0.048204   0.008787    5.486  1.7e-06 ***
x_4         -0.341412   0.008845  -38.601  < 2e-16 ***
x_5         -0.160484   0.008791  -18.255  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.001978 on 46 degrees of freedom
Multiple R-squared:  0.9834,	Adjusted R-squared:  0.982 
F-statistic:   683 on 4 and 46 DF,  p-value: < 2.2e-16
```

which corresponds to a fit of $\mu_1 = -4.379943 + 0.015071x_2 + 0.048204x_3 - 0.341412x_4 - 0.160484x_5$.

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