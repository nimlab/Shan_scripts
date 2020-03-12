function [zmap] = SeedMapper(timecourse,seed,ZscoreTransform,CorCov)
%ZscoreTransform should equal 0 or 1
%CorCov should equal 'cor' or 'cov'

%tc = read_4dfpimg(timecourse);
tc = timecourse;
%roi = read_4dfpimg(seed);
roi = seed;
tc_weighted = tc.*roi;
tc_weighted(find(isnan(tc_weighted)))=0;

%tcroi = mask_4dfpimg(tc_weighted,roi,'remove');
%avgroitc = mean(tcroi,1);
avgroitc = mean(tc_weighted,1);

if CorCov=='cor'
rmap = corr(avgroitc',tc');
zmap = FisherTransform(rmap);
end

if CorCov=='cov'
for i=1:147456
    r = cov(avgroitc',tc(i,:)');
    zmap(i,1) = r(1,2);
end
end


sd = nanstd(zmap);
if ZscoreTransform==1
    zmap = zmap./sd;
end

 %   ZscoreMap = rmap./sd;
%end
%FisherZmap = FisherTransform(rmap);
%stdev = nanstd(FisherZmap,0,1);
%ZscoreMap = FisherZmap./stdev;

%write_4dfpimg(seedmap,[outfileroot '.4dfp.img'],'littleendian');
%write_4dfpifh([outfileroot '.4dfp.img'],1,'littleendian');
%system(['ifh2hdr ' outfileroot])