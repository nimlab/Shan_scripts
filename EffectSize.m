function fx = EffectSize(vector1,vector2);

array1 = vector1;
array2 = vector2;

mean1 = nanmean(array1,2);
mean2 = nanmean(array2,2);
sd1 = nanstd(array1,0,2);
sd2 = nanstd(array2,0,2);
pooledSD = ((sd1.^2+sd2.^2)/2).^0.5;
fx = (mean1 - mean2)./pooledSD;