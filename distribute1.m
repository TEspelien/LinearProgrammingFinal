function [Pertown] = distribute1(saleprice,sol,Prog_no)

% create a new function allocating proportions of overall budget to
% low-high income
n = length(saleprice);
Dummy = ones(4,1);
for i = 1:4
    Dummy(i) = sum(Prog_no(i,:));
end
Dummy2 = zeros(4,size(Prog_no,2));
for i = 1:n
    Dummy2(1,i) = Prog_no(1,i)/Dummy(1);
    Dummy2(2,i) = Prog_no(2,i)/Dummy(2);
    Dummy2(3,i) = Prog_no(3,i)/Dummy(3);
    Dummy2(4,i) = Prog_no(4,i)/Dummy(4);
end
Pertown = ones(4,n);
for i = 1:4
    Pertown(i,:) = Dummy2(i,:)*sol(i);
end