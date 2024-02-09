import sys
from ast import literal_eval
from copy import deepcopy
    

def main():

    desired_composition = literal_eval(''.join(sys.argv[1:]))
    current_composition = [0.0 for _ in desired_composition]
    num_types = len(desired_composition)
    
    current_composition[0] = 1.0
    
    for i in range(1, num_types):
        print(f'set type 1 type/ratio {i + 1} {desired_composition[i] / current_composition[0]} 123456')
        current_composition[i] = desired_composition[i]
        current_composition[0] += -current_composition[i]
        
    
if __name__ == '__main__':

    main()
