import numpy as np
import matplotlib.pyplot as plt

def dominates(solution1, solution2):
    """Check if solution1 dominates solution2."""
    return all(x >= y for x, y in zip(solution1, solution2)) and any(x > y for x, y in zip(solution1, solution2))
    
if __name__ == "__main__":
    f1=[0.8001,0.9106,0.2638,0.1361,0.4314,0.1818,0.1455,0.8693]
    f2=[0.5797,0.145,0.6221,0.5132,0.5499,0.853,0.351,0.4018]

    # Example usage
    sol=np.array([
        [0.8001,0.5797],
        [0.9106,0.145],
        [0.2638,0.6221],
        [0.1361,0.5132],
        [0.4314,0.5499],
        [0.1818,0.853],
        [0.1455,0.351],
        [0.8693,0.4018]
        ])

    sort_on_f1 = sol[np.argsort(sol[:, 0])]
    RANKSET={}
    print(sort_on_f1)
    # Initialize empty arrays for the different categories
    R1 = np.empty((0, 2))
    R2 = np.empty((0, 2))
    R3 = np.empty((0, 2))
    R4 = np.empty((0, 2))
    UNALLOC = np.empty((0, 2))

    # Perform the classification
    for i in range(0, len(sort_on_f1)):
        if dominates(sort_on_f1[i], sort_on_f1[0])==False:
            R1 = np.vstack([R1, sort_on_f1[i]])
        else:
            UNALLOC = np.vstack([UNALLOC, sort_on_f1[i]])
            
    RANKSET['RANK1']=R1
    RANKSET['RANK2']=R2
    RANKSET['RANK3']=R3
    RANKSET['RANK4']=R4

    print(RANKSET,UNALLOC)
  
