import sys
from itertools import combinations
from warnings import warn

import numpy as np


def main():

    # load data from command line
    data = np.loadtxt(sys.argv[1])

    # separate first column of occupying types and energies
    occupying_types = data[:, 0].astype(int) - 1
    energies = data[:, 1:]
    num_sites, num_types = energies.shape

    types = np.arange(num_types, dtype=int)
    pairs = list(combinations(types, r=2))

    num_pairs = len(pairs)

    # initialize matrices for least squares solution
    coefficient_matrix = np.zeros((num_pairs + 1, num_types))
    b = np.zeros(num_pairs + 1)

    # populate coefficient matrix with 1's and -1's representing swaps
    # populate forcing vector with energy differences from swaps
    for index, (first_type, second_type) in enumerate(pairs):
        coefficient_matrix[index, first_type] = 1.0
        coefficient_matrix[index, second_type] = -1.0
        b[index] = np.mean(energies[:, first_type] - energies[:, second_type])

    # put concentrations in last row of coefficient matrix
    concentrations = np.mean(occupying_types == types[:, None], axis=1)
    coefficient_matrix[num_pairs, :] = concentrations

    # get the reference occupying energies, make sure they're all roughly close
    occupying_energies_reference = energies[np.arange(num_sites), occupying_types]
    std = np.std(occupying_energies_reference)
    if not np.isclose(std, 0.0):
        warn(
            f"WARNING: std of occupying reference energies is not close to zero ({std:.2E})"
        )

    # put cohesive reference energy in last element of forcing vector
    b[num_pairs] = np.mean(occupying_energies_reference) / num_sites

    # do least squares to get chemical potentials, print them out with concentrations
    chemical_potentials = np.linalg.lstsq(coefficient_matrix, b, rcond=None)[0]
    print(
        f"{' '.join(concentrations.astype(str))} {' '.join(chemical_potentials.astype(str))}"
    )


if __name__ == "__main__":

    main()
