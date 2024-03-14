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
cd 'D:\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework\Wing Design'
%cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'\'Wing Design'\


%% GA
lb=[ArBounds(1),SwBounds(1),TrBounds(1)];
ub=[ArBounds(2),SwBounds(2),TrBounds(2)];

cdfun=@(Ar_,Sw_,TR_)Wing_Design([Ar_,Sw_,TR_,A1,A2,A3,A4]);

GAOptions = gaoptimset('PopulationSize', 40, 'Generations', 2);
[bestvars, ~, ~, eval_count] = ga(cdfun, 3, [], [], [], [], lb, ub, [], GAOptions);

[vars,obj_cd]=HybridSearch(cdfun,40,2,3,120,lb,ub);

%% functions
function normVal = getNormVal(absVal,bounds)
    normVal=(absVal-bounds(1))/(bounds(2)-bounds(1));
end

function [bestvars2,bestobj2] = HybridSearch(func, pop, gen, numvars,MaxEvalCount, LB, UB)
    bestobj2 = [];
    % Global search
    GAOptions = gaoptimset('PopulationSize', pop, 'Generations', gen);
    [bestvars, ~, ~, eval_count] = ga(func, numvars, [], [], [], [], LB, UB, [], GAOptions);
    % Check if eval_count exceeds 120
    if eval_count > 120
        return; % Terminate function execution
    end
    % Calculate simplexcount
    simplexcount = MaxEvalCount - eval_count;
    % Local search
    options = optimset('MaxFunEvals', simplexcount);
    [bestvars2, bestobj2] = fminsearchcon(func, bestvars, LB, UB, [], [], [], options);
end