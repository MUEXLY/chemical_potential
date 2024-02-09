import sys
from ast import literal_eval
from itertools import product

def main():

    compositions = literal_eval(
        ''.join([item for sublist in sys.argv[1:] for item in sublist])
    )
    possible_compositions = product(*compositions)

    for p in possible_compositions:
        if sum(p) != 1.0:
            continue
        print(list(p))


if __name__ == '__main__':

    main()
