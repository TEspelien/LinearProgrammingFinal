function [Data,n] = eligibility_script(homesales,income,affordability)

n = length(homesales);

affordability_threshold = prctile(affordability, 35)

Data = zeros(4,n);

%{
order of variables:
x1 = LA LI
x2 = LA HI
x3 = HA LI
x4 = HA HI
%}

for j = 1:n
    % determine affordability level for this municipality
    if affordability(j) > affordability_threshold
        Data(1,j) = 1;
        Data(2,j) = 1;
    else
        Data(3,j) = 1;
        Data(4,j) = 1;
    end

    %{
    determine income ditribution:
    in each muni, assume a log normal distribution centered on its median
    skewed towards higher income
    
    when normal distributions are skewed its customary to use the median
    instead of mean to represent the central tendency
    
    find the total area of this distribution below the state median
    %}

    med = income(j);
    mean = med * 1.27; % a rough estimate of mean from median. could change across the state
    mu = log(med);
    s = sqrt((log(mean)-mu)*2);

    dist = makedist('Lognormal','mu',mu,'sigma',s);

    % fraction of people in this muni under the state median
    lo = cdf(dist, 87);

    %fraction of people in this muni between the state median and 150k
    hi = cdf(dist, 150) - lo; 

    % determine max home sales to grant for each category

    %     lo, hi

    Data(1, j) = Data(1, j) * lo * homesales(j);
    Data(2, j) = Data(2, j) * hi * homesales(j);
    Data(3, j) = Data(3, j) * lo * homesales(j);
    Data(4, j) = Data(4, j) * hi * homesales(j);
end