def dominates(solution1, solution2):
    """Check if solution1 dominates solution2."""
    return all(x >= y for x, y in zip(solution1, solution2)) and any(x > y for x, y in zip(solution1, solution2))

def pareto_ranking(solutions):
    """Perform Pareto ranking on a list of solutions."""
    # Sort solutions in descending order based on multiple objective functions
    solutions.sort(reverse=True)
    
    pareto_fronts = []
    while solutions:
        S1 = [solutions.pop(0)]
        dominated_solutions = []
        
        for solution in solutions[:]:
            if any(dominates(s, solution) for s in S1):
                solutions.remove(solution)
                dominated_solutions.append(solution)
            elif any(dominates(solution, s) for s in S1):
                S1.remove(next(s for s in S1 if dominates(solution, s)))
                S1.append(solution)
                solutions.remove(solution)
        
        pareto_fronts.append(S1)
        solutions = dominated_solutions
    
    return pareto_fronts

# Example usage
solutions=[[0.8001,0.5797],[0.9106,0.145],[0.2638,0.6221],[0.1361,0.5132],[0.4314,0.5499],[0.1818,0.853],[0.1455,0.351],[0.8693,0.4018]]
pareto_fronts = pareto_ranking(solutions)

for i, front in enumerate(pareto_fronts):
    print(f"Pareto Front {i+1}: {front}")
