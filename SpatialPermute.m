function [r p] = SpatialPermute(zmaps1,zmaps2,var1,var2,nperm,parworkers)
%Computes spatial correlation with p-value for similarity between two
%lesion network maps, using permutation testing.
%Note: this is a 2-tailed test. If your hypothesis is that the maps should
%be similar or that they're anti-correlated with each other, a 1-tailed
%test may suffice.

%Shan Siddiqi, 6/26/2019

%Required Inputs: zmaps1, zmaps2, var1, and var2
%zmaps1 and zmaps2 are the zmaps for the two datasets being compared. 
%The zmaps should be combined into a 2D matrix of dimensions M x N, where 
%M is the number of voxels in the image, and N is the number of maps.
%In the future, I could modify this script to automatically read out all of
%the maps from a folder and reshape them into the correct size - let me
%know if you want me to do that.

%var1 and var2 should be the two variables that are being compared, stored as vertical column vectors (M x 1). The
%script currently works with binary or continuous variables, but not with
%other categorical variables. Let me know if you want me to modify it to
%include other types of variables.

%Optional inputs: mask,nperm, parworkers
%mask would be a 1d mask that contains specific voxels that you'd like to
%include.
%nperm is the number of permutations you want to run (default = 10,000). A
%smaller number will be faster, a larger number will be more precise.
%parworkers is the number of cores across which to parallelize the process.
%A larger number will make it run faster (don't go above 16 without
%authorization), but will also clog up the server while it's running.


map1 = corr(zmaps1',var1,'rows','complete');
map2 = corr(zmaps2',var2,'rows','complete');
r = corr(map1,map2,'rows','complete');
s1 = size(var1,1);
s2 = size(var2,1);

if nargin<6
    nperm = 10000
end
if nargin<7
    parworkers = 1
end

parpool(parworkers)
parfor i=1:nperm
    a = corr(zmaps1',var1(randperm(s1)),'rows','complete');
    b = corr(zmaps2',var2(randperm(s2)),'rows','complete');
    shuffle(i) = corr(a,b,'rows','complete');
end

p = size(shuffle(abs(shuffle)>abs(r)));
p = p/nperm;