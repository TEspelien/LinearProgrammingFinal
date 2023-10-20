function [Pertown] = distribute1(sol, eligible)

% create a new function allocating proportions of overall budget to
% low-high income
n = length(eligible);
Dummy = ones(4,1);
for i = 1:4
    Dummy(i) = sum(eligible(i,:));
end
Dummy2 = zeros(4,n);
for i = 1:n
    Dummy2(1,i) = eligible(1,i)/Dummy(1);
    Dummy2(2,i) = eligible(2,i)/Dummy(2);
    Dummy2(3,i) = eligible(3,i)/Dummy(3);
    Dummy2(4,i) = eligible(4,i)/Dummy(4);
end
Pertown = ones(4,n);
for i = 1:4
    Pertown(i,:) = floor(Dummy2(i,:)*sol(i));
end