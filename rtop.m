%Convert r-value to p-value

function [p t] = rtop(r,n)

format long

d = r*sqrt(n-2);
%t = double(t);
t = d/sqrt(1-r^2);
t = double(t);
p = 2*(1 - tcdf(abs(t),n));
end
