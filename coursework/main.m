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

cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'
%cd 'D:\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'
%% Evaluate all possible objective values of TestFunction3 while staying within the max evaluation count budget
MaxEvalN=120;
LB=[0,0,0,0,0,0];
UB=[1,1,1,1,1,1];

% Get all objective value of test function 3 and save to a .mat file
filename='TestFunc3GlobalObjVal2.mat';
getGlobalObjVal(@Test_Function3,MaxEvalN,LB,UB,120,120,10,filename)

%% Load all objective values and filter out empty rows
% Run this cell ONLY after evaluating all possible Objective Values of TestFunction 3

% Find rows with any empty cells
%cd 'D:\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework\Data\RUN3'
%cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework\Data\RUN3'
load(filename, 'dataTable')
emptyRows = any(cellfun(@isempty, table2cell(dataTable)), 2);

% Remove rows with any empty cells
TestFunc3GlobalObjVal = dataTable(~emptyRows, :);
TestFunc3GlobalObjVal=sortrows(TestFunc3GlobalObjVal,'ObjVal');

% Remove rows with > 120 GA eval counts
% Convert cell values to numeric format
col2_numeric = cell2mat(TestFunc3GlobalObjVal{:, 2});
col3_numeric = cell2mat(TestFunc3GlobalObjVal{:, 3});

% Find rows where the value of the second column multiplied by the third column exceeds 120
exceedsThreshold = col2_numeric .* col3_numeric > 120;
% Remove rows where the condition is true
TestFunc3GlobalObjVal = TestFunc3GlobalObjVal(~exceedsThreshold, :);

% Find rows where population is 1
belowThreshold = col2_numeric == 1;
% Remove rows where the condition is true
TestFunc3GlobalObjVal = TestFunc3GlobalObjVal(~belowThreshold, :);

aTestFunc3GlobalObjVal=cell2mat(table2array(TestFunc3GlobalObjVal));

%% Determine best GA evaluations to SIMPLEX evaluation ratio
% Assuming x1 and x2 values are integers, convert them to categorical
P1_pop = categorical(aTestFunc3GlobalObjVal(:,3));
P2_gen = categorical(aTestFunc3GlobalObjVal(:,2));
O1=aTestFunc3GlobalObjVal(:,1);
F=min(O1);

% Group the data based on x1 and x2 categories
groups = cellstr(strcat('POP_', cellstr(P1_pop), '_GEN_', cellstr(P2_gen)));
unique_groups = unique(groups);

% RMSE for data mean and best minimal (consistency and accuracy)

O1rmse_min = zeros(size(unique_groups));
for i = 1:length(unique_groups)
    idx = strcmp(groups, unique_groups{i});
    O1rmse_min(i) = rmse(F,aTestFunc3GlobalObjVal(idx, 1));
end

O1rmse_mean = zeros(size(unique_groups));
for i = 1:length(unique_groups)
    idx = strcmp(groups, unique_groups{i});
    O1rmse_mean(i) = rmse(mean(aTestFunc3GlobalObjVal(idx, 1)),aTestFunc3GlobalObjVal(idx, 1));
end

O1MAT=[O1rmse_min,O1rmse_mean];
ParetoOptimalTest1=pareto_frontier(O1MAT,false,false);
figure
hold on
scatter(O1MAT(:,1),O1MAT(:,2))
scatter(ParetoOptimalTest1(1),ParetoOptimalTest1(2))
hold off

% We found that we only have one pareto optimal point
RowIDX=find(ismember(O1MAT,ParetoOptimalTest1,'rows'));
poptimalObjVal=aTestFunc3GlobalObjVal(RowIDX,1);
poptimalPop=aTestFunc3GlobalObjVal(RowIDX,3);
poptimalGen=aTestFunc3GlobalObjVal(RowIDX,2);


% Standard deviation vs RMSE (x runs for each pop and gen combo)
% Calculate standard deviation for each group
O1std_2 = zeros(size(unique_groups));
for i = 1:length(unique_groups)
    idx = strcmp(groups, unique_groups{i});
    O1std_2(i) = std(aTestFunc3GlobalObjVal(idx, 1));
end

% Calculate RMSE for each group
O1rmse_2 = zeros(size(unique_groups));
for i = 1:length(unique_groups)
    idx = strcmp(groups, unique_groups{i});
    O1rmse_2(i) = rmse(F,aTestFunc3GlobalObjVal(idx, 1));
end

O1MAT2=[O1rmse_2,O1std_2];
ParetoOptimalTest2=pareto_frontier(O1MAT2,false,false);

figure
hold on
scatter(O1std_2,O1rmse_2)
scatter(ParetoOptimalTest2(:,1),ParetoOptimalTest2(:,2))
hold off

% We found that we only have one pareto optimal point
RowIDX=find(ismember(O1MAT2,ParetoOptimalTest2,'rows'));
poptimalObjVal2=aTestFunc3GlobalObjVal(RowIDX,1);
poptimalPop2=aTestFunc3GlobalObjVal(RowIDX,3);
poptimalGen2=aTestFunc3GlobalObjVal(RowIDX,2);

% Residual vs stddev
% Calculate residual for each group
O1res_2 = zeros(size(unique_groups));
for i = 1:length(unique_groups)
    idx = strcmp(groups, unique_groups{i});
    O1res_2(i)=mean(aTestFunc3GlobalObjVal(idx, 1)-ones(length(aTestFunc3GlobalObjVal(idx, 1)),1)*F);
end


O1MAT3=[O1std_2,O1res_2];
ParetoOptimalTest3=pareto_frontier(O1MAT3,false,false);

figure
hold on
scatter(O1std_2,O1res_2)
scatter(ParetoOptimalTest3(:,1),ParetoOptimalTest3(:,2))
hold off

% We found that we only have one pareto optimal point
RowIDX=find(ismember(O1MAT3,ParetoOptimalTest3,'rows'));
poptimalObjVal3=aTestFunc3GlobalObjVal(RowIDX,1);
poptimalPop3=aTestFunc3GlobalObjVal(RowIDX,3);
poptimalGen3=aTestFunc3GlobalObjVal(RowIDX,2);

%% Decide which Pareto optimal set to use
optPop=poptimalPop3;
optGen=poptimalGen3;

%% Run Wing Design

ArBounds=[6,12];
SwBounds=[14,20];
TrBounds=[0.2,1.0];
A1Bounds=[-0.01,0.01];
A2Bounds=[-0.01,0.01];
A3Bounds=[-0.01,0.01];
A4Bounds=[-0.01,0.01];
lb=[0,0,0,0,0,0,0];
ub=[1,1,1,1,1,1,1];

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

A1=0.50;
A2=0.50;
A3=0.50;
A4=0.50;

cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework\Wing Design'
cdfun=@(VARS)Wing_Design(VARS);

[vars,obj_cd]=HybridSearch(cdfun,optPop,optGen,7,MaxEvalN,lb,ub);
filename2="TaskaWingDesign.mat";
save(filename2,"vars","obj_cd","-mat");
%run1
%vars=[0.993040941467052,0.999634607270934,1.844869840607055e-04]
%objcd=0.011632420318577
%%
%{
%% Task (b)

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



%% Test if wing design module is working
cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'\'Wing Design'\
CD=Wing_Design([VARS,A1,A2,A3,A4]);
%}

%% Functions

function normVal = getNormVal(absVal,bounds)
    normVal=(absVal-bounds(1))/(bounds(2)-bounds(1));
end

function resultarr=getGlobalObjVal(func,maxn,lb,ub,popsweep,gasweep,repn,filename)
    %fun=@(pop,gen)HybridSearchPrototype(func,pop,gen,maxn,lb,ub);
    %{
    % Initialize cell arrays to store data
    objvalarr_ = zeros(N,1);
    genarr_ = zeros(N,1);
    poparr_ = zeros(N,1);
    % Collect data
    for i = 1:popsweep
        for j = 1:gasweep
            %run 10 times per ga and pop combo
            parfor count=1:repn
                objvalarr_(i) = fun(i, j);
                genarr_(i) = j;
                poparr_(i) = i;
            end
            disp(['Generation:  ',num2str(j),'  out of    120'])
        end
        disp(['Population:  ',num2str(i),'  out of    120'])

    end
    %}
    % Initialize cell arrays to store data
    objvalarr_ = cell(popsweep, gasweep);
    genarr_ = cell(popsweep, gasweep);
    poparr_ = cell(popsweep, gasweep);
    % Collect data
    parfor i = 1:popsweep
        for j = 1:gasweep
            % Run 'repn' times per ga and pop combo
            for count = 1:repn
                objvalarr_{i, j}{count} = HybridSearchPrototype(func,i,j,maxn,lb,ub);
                genarr_{i, j}{count} = j;
                poparr_{i, j}{count} = i;
                disp(['i:  ', num2str(i), '  j:    ', num2str(j), ' count   ',num2str(count)])
            end
            disp(['i:  ', num2str(i), '  j:    ', num2str(j), ' count   ',num2str(count)])
        end
    disp(['i:  ', num2str(i), '  j:    ', num2str(j), ' count   ',num2str(count)])
    end

   % Flatten cell arrays into column vectors
    objval_col = cellfun(@(x) x(:), objvalarr_, 'UniformOutput', false);
    objval_col = cat(1, objval_col{:});
    
    gen_col = cellfun(@(x) x(:), genarr_, 'UniformOutput', false);
    gen_col = cat(1, gen_col{:});
    
    pop_col = cellfun(@(x) x(:), poparr_, 'UniformOutput', false);
    pop_col = cat(1, pop_col{:});
    
    % Create table
    dataTable = table(objval_col, gen_col, pop_col, 'VariableNames', {'ObjVal', 'Gen', 'Pop'});
    
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

function pfront=pareto_frontier(inputmat,maxX,maxY)
    tinput=array2table(inputmat);
    if maxX==true
        tinput=sortrows(tinput,1,'descend');
    else
        tinput=sortrows(tinput,2,'ascend');
    end
    ainput=table2array(tinput);
    pfront=ainput(1,:);
    for i=2:size(ainput,1)
        pair=ainput(i,:);
        if maxY==true
            if pair(2) >= pfront(end,2)
                pfront=[pfront;pair];
            end
        else
            if pair(2) <= pfront(end,2)
                pfront=[pfront;pair];
            end
        end
    end

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
