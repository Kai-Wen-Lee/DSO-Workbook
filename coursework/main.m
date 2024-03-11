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
        3. How to take the random nature of GA into account?

    Indicators of good method:
        1.  Consistency
        2.  Accuracy

    - Metrics: Probabilities, standard deviation
    - Suggested: Use Pareto front

    NOTE:
        - Try to find a balance between consistency and accuracy as they
        may be competing objectives.
%}

cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'

%% Task (b)
%{
    Wing_Design.p       -> Gets CD
    Wing_Design_Info.p  -> Gets CD and graphics

    Tasks:
        1. Perform design optimisation of light aircraft wing.
            - Starting from a shit box, try to get a Ferrari
%}
%% Design variables
% Baseline stats:
Ar_bl=7.5;
Sw_bl=16;
lambda_bl=0.4;
CL_bl=0.342;
CD_bl=0.0147;
CDv_bl=0.0056;
CDvis_bl=0.0091;
LDR_bl=23.3;

% Design variables (normalised)
Ar=6/Ar_bl;
Sw=14/Sw_bl;
lambda=0.2/lambda_bl;
VARS=[Ar,Sw,lambda];
A1=0.50;
A2=0.50;
A3=0.50;
A4=0.50;
%% Constraints
MaxEvalN=120; % We only have a total budget of 120 function evaluations

%% Test if wing design module is working
cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'\'Wing Design'\
CD=Wing_Design([VARS,A1,A2,A3,A4]);