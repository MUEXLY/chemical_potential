from itertools import combinations
import sys

import numpy as np


def main():

    data = np.loadtxt("example/output/chemical_potentials.txt", skiprows=1)
    _, num_columns = data.shape
    num_types = num_columns // 2

    compositions = data[:, :num_types]
    chemical_potentials = data[:, num_types:]
    free_energies = np.sum(compositions * chemical_potentials, axis=1)

    # feature names
    feature_names = [f"x_{i + 1:.0f}" for i in range(num_types)]

    # linear terms
    input_data = compositions.copy()

    # add quadratic terms
    for i, j in combinations(range(num_types), 2):
        input_data = np.append(input_data, (compositions[:, i] * compositions[:, j]).reshape(-1, 1), axis=1)
        feature_names.append(f"x_{i + 1:.0f}x_{j + 1:.0f}")

    fit = np.linalg.pinv(input_data) @ free_energies

    residuals = input_data @ fit - free_energies
    inaccuracy = np.linalg.norm(residuals) / np.linalg.norm(free_energies - free_energies.mean())
    pcc = 1.0 - inaccuracy ** 2
    print(f"RMSE: {np.sqrt(np.mean(residuals ** 2))}")
    print(f"PCC: {pcc:.6f}")
    print(" ".join(feature_names))
    print(np.array2string(fit))
    #np.savetxt(sys.argv[2], fit.reshape(1, -1), header=" ".join(feature_names))


if __name__ == "__main__":

    main()
