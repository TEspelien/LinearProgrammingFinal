med = 95;
mean = med * 1.27;
mu = log(med);
s = sqrt((log(mean)-mu)*2);

dist = makedist('Lognormal','mu',mu,'sigma',s)

x = (10:510)';
y = pdf(dist,x);

plot(x,y)

lo = cdf(dist, 87)
hi = cdf(dist, 150) - lo
