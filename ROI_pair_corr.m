                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                function z = ROI_pair_corr(seed1,seed2,timecourse,inputtype)
%if inputtype=1, then inputs are filenames
%if inputtype=2, then inputs are matrices

if inputtype==1
tc = read_4dfpimg(timecourse);
roi1 = read_4dfpimg(seed1);                                                                                                                                                                                                                                                                                                         
roi2 = read_4dfpimg(seed2);
end
if inputtype==2
        tc = timecourse;
        roi1 = seed1;
        roi2 = seed2;
end

tc1_wt = tc.*roi1;
tc2_wt = tc.*roi2;
%tc1_wt = tc;
%tc2_wt = tc;

avgroitc1 = mean(mask_4dfpimg(tc1_wt,roi1,'remove'),1);
avgroitc2 = mean(mask_4dfpimg(tc2_wt,roi2,'remove'),1);

z = FisherTransform(corr(avgroitc1',avgroitc2'));