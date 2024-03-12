clear all
close all

%% Task (a)
%{
    ga()                -> Performs evolutionary global search.
                        -> Parameter: Population, Generation
    fminsearchcon()     -> Performs a simplex local search.
                        -> Parameter: Number of evaluations.

    Questions:
        2. How to investigate the impact of population size, number of
        generations and split in evaluations between GA and simplex?
            - Pareto search
        3. How to take the random nature of GA into account?
            - Confidence interval
%}

%cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'
cd 'D:\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'
%% Evaluate all possible objective values of TestFunction3 while staying within the max evaluation count budget
MaxEvalN=120;
LB=[0,0,0,0,0,0];
UB=[1,1,1,1,1,1];

% Get all objective value of test function 3 and save to a .mat file
filename='TestFunc3GlobalObjVal.mat';
%getGlobalObjVal(@Test_Function3,MaxEvalN,LB,UB,filename)

%% Load all objective values and filter out empty rows
% Run this cell ONLY after evaluating all possible Objective Values of TestFunction 3

% Find rows with any empty cells
load(filename, 'dataTable')
emptyRows = any(cellfun(@isempty, table2cell(dataTable)), 2);
% Remove rows with any empty cells
TestFunc3GlobalObjVal = dataTable(~emptyRows, :);
TestFunc3GlobalObjVal=sortrows(TestFunc3GlobalObjVal,'ObjVal');

aTestFunc3GlobalObjVal=cell2mat(table2array(TestFunc3GlobalObjVal));

%% Determine best GA evaluations to SIMPLEX evaluation ratio

%{
    x1 dominates x2 if:
        1) Solution x1 is no worse than x2 in all objectives
        2) Solution x1 is strictly better than x2 in at least one objective
    We now have 2 objectives:
        1) Consistency
        2) Accuracy
    Use Mishra-Harit method

    What is the best measure of consistency here?
    What is the best measure of accuracy here?
%}
P1_pop=aTestFunc3GlobalObjVal(:,2);
P2_gen=aTestFunc3GlobalObjVal(:,3);
O1=aTestFunc3GlobalObjVal(:,1);

F=min(O1);
O1rfse=rmse(F,O1,2); %Accuracy measure
O1rmse=rmse(mean(O1),O1,2); %Consistency measure
S1=mishra_harit_algorithm(P1_pop, P2_gen, O1rfse, O1rmse);
% Extract objective values from the solution set
objectives = cell2mat(S1);

% Plot the solutions in the objective space
scatter(objectives(:, 3), objectives(:, 4), 'filled');
xlabel('Objective 1 (O1)');
ylabel('Objective 2 (O2)');
title('Solution Set');
grid on;
%% Determine best generation and population for GA

%% Run Wind_Design based on best generation count, population and GA-TO-SIMPLEX evaluation ratio

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

function resultarr=getGlobalObjVal(func,maxn,lb,ub,filename)
    fun=@(pop,gen)HybridSearchPrototype(func,pop,gen,maxn,lb,ub);
    % Initialize cell arrays to store data
    objvalarr_ = {};
    genarr_ = {};
    poparr_ = {};
    
    % Collect data
    for i = 1:120
        for j = 1:120
            if ~isempty(fun(i, j))
                objvalarr_{end+1} = fun(i, j);
                genarr_{end+1} = j;
                poparr_{end+1} = i;
            end
            disp(['Generation:  ',num2str(j),'  out of    120'])
        end
        disp(['Population:  ',num2str(i),'  out of    120'])

    end
    
    % Convert cell arrays to arrays of the same length
    max_length = max([numel(objvalarr_), numel(genarr_), numel(poparr_)]);
    objvalarr_ = [objvalarr_, cell(max_length - numel(objvalarr_), 1)];
    genarr_ = [genarr_, cell(max_length - numel(genarr_), 1)];
    poparr_ = [poparr_, cell(max_length - numel(poparr_), 1)];
    
    % Create table
    dataTable = table(objvalarr_', genarr_', poparr_', 'VariableNames', {'ObjVal', 'Gen', 'Pop'});
    
    % Save table to .mat file
    save(filename, 'dataTable');


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

function res=getResidual(O1)
    res=[];
    for i=1:numel(O1)
        res=cat(1,res,(O1(i)-min(O1)));
    end
end

function S1 = mishra_harit_algorithm(P1, P2, O1, O2)

end

