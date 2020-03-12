function [r p LOOpredictor] = LOO(zmaps,measure,covariates)
%Leave one out analysis using an M x N matrix of zmaps and an N x 1 matrix
%of measurements to predict.

s = size(measure,1);

h = waitbar(0,'wait');

if nargin==2
for i=1:s
    waitbar(i/s);
    tmp = zmaps;
    tmp2 = measure;
    tmp(:,i) = [];
    tmp2(i) = [];
    LOOmaps(:,i) = corr(tmp',tmp2,'rows','complete');
end

for i=1:s
    tmp = zmaps(:,i);
    tmp2 = corr(tmp,LOOmaps(:,i),'rows','complete');
    LOOpredictor(i) = tmp2;
end

[r p] = corr(LOOpredictor',measure);

else
    for i=1:s
    waitbar(i/s);
    tmp = zmaps;
    tmp2 = measure;
    tmp3 = covariates;
    tmp(:,i) = [];
    tmp2(i) = [];
    tmp3(i,:)=[];
    LOOmap = partialcorr(tmp',tmp2,tmp3,'rows','complete');
    tmpmap = zmaps(:,i);
    LOOpredictor(i) = corr(tmpmap,LOOmap,'rows','complete');
end


[r p] = partialcorr(LOOpredictor',measure,covariates);
end