import sys
from ast import literal_eval
from copy import deepcopy
from random import randint


def main():

    # evaluate desired composition from command line
    desired_composition = literal_eval("".join(sys.argv[1:]))

    # initialize current composition
    # first we start with a 100% sample with first type, then slowly "steal" from that element
    current_composition = [0.0 for _ in desired_composition]
    current_composition[0] = 1.0

    num_types = len(desired_composition)

    for i in range(1, num_types):
        seed = randint(0, 1_000_000)
        print(
            f"set type 1 type/ratio {i + 1} {desired_composition[i] / current_composition[0]} {seed:.0f}"
        )
        # "steal" from element at first index, populate into element at index i
        current_composition[i] = desired_composition[i]
        current_composition[0] += -current_composition[i]


if __name__ == "__main__":

    main()
