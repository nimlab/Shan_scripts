function [SymptomCorr corrmats] = corrmat_symptom_correlator(sublist,dataset,measures)
%varargin = 3d matrix of corrmats

numsubs = size(sublist,1);

parfor i=1:numsubs
   if dataset=='Fox'
       sub = [num2str(sublist(i)) '_pre'];
   else
       sub = sublist{i};
   end
   corrmats(:,:,i) = corrmat(sub,dataset,1,1);
end

numrois = size(corrmats,1);

for i=1:numrois
    for j=1:numrois
        clear tmp;
        tmp(:) = corrmats(i,j,1:numsubs);
        SymptomCorr(i,j) = corr(measures,tmp');
    end
end

SymptomCorr = FisherTransform(SymptomCorr);