import sys
from ast import literal_eval
from itertools import product
from random import shuffle


def main():

    # evaluate compositions from command line, get all possible combinations of compositions
    compositions = literal_eval(
        "".join([item for sublist in sys.argv[1:] for item in sublist])
    )
    possible_compositions = list(product(*compositions))
    shuffle(possible_compositions)

    # only print out composition if it sums to 1
    for p in possible_compositions:
        if sum(p) != 1.0:
            continue
        print(list(p))


if __name__ == "__main__":

    main()
