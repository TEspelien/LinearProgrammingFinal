clc; clear all; close all;

Data = readtable("MA3231 final data - Sheet1.csv", "ReadVariableNames",true);

n = height(Data) - 1

populations = table2array(Data(2:end, "population"));
sum(populations)

incomes = table2array(Data(2:end,"medianIncome"));
homesales = table2array(Data(2:end,"monthlyHomeSales"));
homeprices = table2array(Data(2:end,"medianSalePrice"));

homeprices = homeprices * 0.75;

homesales = homesales * 0.13;

plot(affordability)


Prog_no = eligibility_script(homesales,homeprices, incomes);
for i = 1:4
    eligible(i) = sum(Prog_no(i,:));
end
LIweight = 80;
Budget = 1e7;

max_budget = 0.015 * 56e9; % cap at 1.5% of total mass annual budget (about 56 billion)

for n = 1:100
    Budget = n/100*max_budget /12; % slowly increase monthly budget up to 100% of max
    [temp1, temp2] = programsolver(Budget, eligible);
    obj(n) = temp1;
    results(:,n) = temp2(1:4);
    budj(n) = Budget;
end

    
figure(1)
plot(budj(1:n),obj)

figure(2)
hold on
plot(budj(1:n),results(1,:));
plot(budj(1:n),results(2,:));
plot(budj(1:n),results(3,:));
plot(budj(1:n),results(4,:));
legend("LI,LA","HI,LA", ...
    "LI,HA","HI,HA",location='northwest')

optimal_idx = 50;

%find the index where the objective function levels off
for idx = 100:-1:2
    if(obj(idx-1) == obj(idx))
        optimal_idx = idx-1;
    end
end

obj(optimal_idx-1:optimal_idx+1); %confirm

sol = results(:, optimal_idx)

%monthly counts of people helped and budjet
(sol(1)+sol(2))*5e4 + (sol(3)+sol(4))*3e4
budj(optimal_idx)
   

Pertown = distribute1(sol, Prog_no);