function etasquared = eta(mat1,mat2)
mbar = (mean(mat1)+mean(mat2))/2;

for i=1:size(mat1,1)
    a = mat1(i);
    b = mat2(i);
    m = (a+b)/2;
    ss_top(i) = (a-m)^2 + (b-m)^2;
    ss_bottom(i) = (a-mbar)^2 + (b-mbar)^2;
end

etasquared = 1 - ss_top/ss_bottom;