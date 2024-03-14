clear all
close all
cd 'D:\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'

%cd 'C:\Users\Kai Wen Lee\OneDrive - University of Southampton\UoS_2023_24\FEEG_DSO\Workbook\DSO-Workbook\coursework'
Test_Function1([0.25;0.5]) %check if PATH is set correctly

%% Test function 1
%Global search
GAOptions=gaoptimset('PopultionSize',10,'Generations',5);
[bestvar,bestobj,history,eval_count]=ga(@Test_Function1,2,[],[],[],[],[0,0],[1,1],[],GAOptions);

%Local search
options=optimset('MaxFunEvals',200);
[bestvar2,bestobj2]=fminsearchcon(@Test_Function1,[0.1,0.9],[0,0],[1,1],[],[],[],options);

%% Test function 2
%Global search
GAOptions=gaoptimset('PopultionSize',10,'Generations',5);
[bestvar3,bestobj3,history3,eval_count3]=ga(@Test_Function2,2,[],[],[],[],[0,0],[1,1],[],GAOptions);

% Local search
options=optimset('MaxFunEvals',200);
[bestvar4,bestobj4]=fminsearchcon(@Test_Function2,[0.1,0.9],[0,0],[1,1],[],[],[],options);

% Plot results
NO_PTS=51;
x=linspace(0,1,NO_PTS);
for i=1:NO_PTS;
    for j=1:NO_PTS;
        Y(j,i)=Test_Function2([x(i);x(j)]);
    end
end
surf(x,x,Y);
xlabel('x_l');
ylabel('x_2');
zlabel('f(x)');

%% Test function 3
%Global search
GAOptions=gaoptimset('PopultionSize',98,'Generations',2);
[bestvar5,bestobj5,history5,eval_count5]=ga(@Test_Function3,6,[],[],[],[],[0,0,0,0,0,0],[1,1,1,1,1,1],[],GAOptions);

% Local search
options=optimset('MaxFunEvals',300);
[bestvar6,bestobj6]=fminsearchcon(@Test_Function3,bestvar5,[0,0,0,0,0,0],[1,1,1,1,1,1],[],[],[],options);