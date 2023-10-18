function [obj, results] = programsolver(Budget, eligible)
% config
LA_HA_split = [60 40]; % LA at least 60%, HA at most 40% of all grants
LI_HI_split = [80 20]; % LI at least 80%, HI at most 20% of all grants

ar = LA_HA_split(1)/LA_HA_split(2); %low/high ratio
ir = LI_HI_split(1)/LI_HI_split(2);

% objective function doesn't change, all weighting occurs in constraints.
f = [-1 -1 -1 -1];

%{
order of variables:
x1 = LA LI - the main target of this program
x2 = LA HI
x3 = HA LI - likely a very small number of people
x4 = HA HI - lowest priority of this program
%}

%{
constraints:
1. cost of program < max budget
2. preference for LA: (x1 + x2) > ar (x3 + x4) <-> -x1-x2+ar(x3+x4) < 0
3. preference for LI within LA: x1 > ir x2 <-> -x1 + ir x2 < 0
4. preference for LI within HA: x3 > ir x4 <-> -x3 + ir x4 < 0
5-8. xi < eligible grants per category
9-12. xi > 0
%}

% constraints LHS
A(1,1:4) = [5e4 5e4 3e4 3e4];
A(2,1:4) = [-1 -1 ar ar];
A(3,1:4) = [-1 ir 0 0];
A(4,1:4) = [0 0 -1 ir];
A(5:8,1:4) = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
A(9:12,1:4) = [-1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 -1];
b(1) = Budget;
b(2) = 0;
b(3) = 0;
b(4) = 0;
b(5:8) = eligible(1:4);
b(9:12) = 0;

results = linprog(f,A,b);
obj = sum(results);