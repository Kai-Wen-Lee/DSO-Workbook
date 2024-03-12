% Define Objective Functions
function [f1, f2] = objectives(x)
    f1 = x.^2;
    f2 = (x - 2).^2;
end

% NSGA-II Algorithm
populationSize = 100;
maxGenerations = 100;
mutationRate = 0.1;
crossoverFraction = 0.8;

problem.objective = @objectives;
problem.nvars = 1;
problem.lb = 0;
problem.ub = 5;

options = optimoptions('gamultiobj', ...
    'PopulationSize', populationSize, ...
    'MaxGenerations', maxGenerations, ...
    'MutationFcn', {@mutationadaptfeasible, mutationRate}, ...
    'CrossoverFraction', crossoverFraction);

[x, fval, exitflag, output, population, scores] = gamultiobj(problem, options);

% Plot Pareto Front
figure;
plot(fval(:,1), fval(:,2), 'bo');
xlabel('Objective 1');
ylabel('Objective 2');
title('Pareto Front');
grid on;
