clear all
close all

%% Task (a)
%{
    ga()                -> Performs evolutionary global search.
                        -> Parameter: Population, Generation
    fminsearchcon()     -> Performs a simplex local search.
                        -> Parameter: Number of evaluations.

    Questions:
        1. How to carry this out?

        2. How to investigate the impact of population size, number of
        generations and split in evaluations between GA and simplex?
            - Pareto search
        3. How to take the random nature of GA into account?
            - Confidence interval

    Indicators of good method:
        1.  Consistency
        2.  Accuracy

    - Metrics: Probabilities, standard deviation
    - Suggested: Use Pareto front

    NOTE:
        - Try to find a balance between consistency and accuracy as they
        may be competing objectives.

    Strategy:
        1. 
%}

cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'

%% Hybrid optmisation strategy
MaxEvalN=120;
LB=[0,0,0,0,0,0];
UB=[1,1,1,1,1,1];

% Call HybridSearch function
fun=@(pop,gen)HybridSearchPrototype(@Test_Function3,pop,gen,MaxEvalN,LB,UB);
%{
objval=[];
resultarr={};
for i=10:20
    for j=5:10 
        if isempty(fun(i,j))
            %donothing
        else
            objval=cat(1,objval,fun(i,j));
            resultarr{end+1}={i,j,objval(end)};
        end
    end
end
% Extract objective values from resultarr
obj_values = cellfun(@(x) x{3}, resultarr);

% Find the minimum value and its index
[min_value, min_index] = min(obj_values);

% Display the minimum value and its corresponding index
disp(['Minimum value: ', num2str(min_value)]);
pop = resultarr{min_index}{1};
gen = resultarr{min_index}{2};
objval = resultarr{min_index}{3};
disp(['Pop and gen at minimum objval: ', num2str(pop), ', ', num2str(gen), ', ', num2str(objval)]);

%}
GAOptions = gaoptimset('PopulationSize', 20, 'Generations', 20);
[bestvar, bestobjval, history, evalN] = ga(fun, 2, [], [], [], [], [0,120], [0,120], [], GAOptions);
%%
%{
%% Task (b)
%{
    Wing_Design.p       -> Gets CD
    Wing_Design_Info.p  -> Gets CD and graphics

    Tasks:
        1. Perform design optimisation of light aircraft wing.
            - Starting from a shit box, try to get a Ferrari
%}
%% Constraints
%{
    AR          between 6 and 12
    Sw          between 14 and 20
    TR          between 0.2 and 1.0
    A1 - A4     between -0.01 and 0.01
%}

ArBounds=[6,12];
SwBounds=[14,20];
TrBounds=[0.2,1.0];
A1Bounds=[-0.01,0.01];
A2Bounds=[-0.01,0.01];
A3Bounds=[-0.01,0.01];
A4Bounds=[-0.01,0.01];

%% Design variables
% Baseline stats:
Ar_bl=7.5;
Sw_bl=16;
TR_bl=0.4;
CL_bl=0.342;
CD_bl=0.0147;
CDv_bl=0.0056;
CDvis_bl=0.0091;
LDR_bl=23.3;

% Design variables (normalised)
Ar=getNormVal(Ar_bl,ArBounds);
Sw=getNormVal(Sw_bl,SwBounds);
TR=getNormVal(TR_bl,TrBounds);
VARS=[Ar,Sw,TR];

A1=0.50;
A2=0.50;
A3=0.50;
A4=0.50;

%% Test if wing design module is working
cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'\'Wing Design'\
CD=Wing_Design([VARS,A1,A2,A3,A4]);
%}
%% Functions

function normVal = getNormVal(absVal,bounds)
    normVal=(absVal-bounds(1))/(bounds(2)-bounds(1));
end

function bestobj2 = HybridSearchPrototype(func, pop, gen, MaxEvalCount, LB, UB)
    % Initialize bestobj2 to an empty value
    bestobj2 = [];

    % Global search
    GAOptions = gaoptimset('PopulationSize', pop, 'Generations', gen);
    [bestvars, ~, ~, eval_count] = ga(func, 6, [], [], [], [], LB, UB, [], GAOptions);
    
    % Check if eval_count exceeds 120
    if eval_count > 120
        return; % Terminate function execution
    end
    
    % Calculate simplexcount
    simplexcount = MaxEvalCount - eval_count;
    
    % Local search
    options = optimset('MaxFunEvals', simplexcount);
    [~, bestobj2] = fminsearchcon(func, bestvars, LB, UB, [], [], [], options);
end




