function [TargetAtlas,voxels] = GroupMatrixCorr(nii_circuit,parworkers,corrtype)
%Last revision: 4/1/2019
%Shan Siddiqi, ssiddiqi@bidmc.harvard.edu
%Feel free to contact me for help.

%This script uses the group connectome matrix to generate prospective TMS
%targets that will hit your circuit of interest. It parses the voxel-wise
%cross-correlation matrix for the whole connectome, which contains a
%connectivity map for every voxel in the brain. For each voxel's
%connectivity map, it calculates the spatial correlation with your map of
%interest. Then it plots it back onto the brain.
%***************
%INPUTS:
%nii_circuit: filename/path of the nifti file containing your circuit of
%interest (in 'single quotes')
%parworkers: number of processing cores to use for the calculation. This will
%determine how much horsepower you will use for the computation.
%If you don't know what this means, then use 1 and just let it run overnight. 
%
%If you use 1 core, the whole process will take something on the order of 
%10-20 hours, depending on how fast your computer is. If
%you're a novice user, don't use more than 2 cores without getting approval
%from the person who runs your server. If you're an expert user, you can use as
%many cores as the server allows. The lab's Millennium Falcon and Shan's Death
%Star can safely use 16 cores if nobody else is using it, but you shouldn't
%do that unless you are willing to take responsibility for possibly
%overloading the server!


%***********************************
%IMPORTANT!!!!!
%Before first use, update the file paths below
%***********************************

addpath(genpath('/data1/nimlab/connectomes/software/leaddbs'));
addpath('/data1/nimlab/connectomes/software/spm12');

object = matfile('/data/nimlab/GroupMatrix/AllX.mat','Writable',true);
load('/data/nimlab/GroupMatrix/dataset_info.mat','dataset');



circuit_nii = load_nifti(nii_circuit);
circuit = circuit_nii.vol;

outidx = dataset.vol.outidx;

circuit_masked = zeros(1,285903);

for i=1:285903
idx = outidx(i);
circuit_masked(i) = circuit(idx);
end

voxels_sorted = zeros(1000,286);

parpool(parworkers)
parfor i=1:286
k = i*1000;
j = ((i-1)*1000)+1;
%bin = object.X(j:k,:)';
if i < 286
    bin = object.X(1:285903,j:k);
    %bin = object.X(98:286000,j:k);
else
    bin = [object.X(1:285903,j:285903),zeros(285903,97)];
    %bin = [object.X(98:286000,j:285903),zeros(285903,97)];
end

bin_real = single(bin);
voxels_sorted(:,i) = corr(bin_real,circuit_masked','rows','pairwise','type',corrtype);

%voxels_sorted(:,i) = corr(bin_real,circuit_masked','rows','pairwise','type',corrtype);

end

voxels = reshape(voxels_sorted,[286000,1]);
%voxels = reshape(voxels_sorted,[285903,1]);
%tmp = voxels(1:285903);
%tmp2 = zeros(97,1);
%voxels = [tmp2;tmp];



TargetAtlas = zeros(902629,1);

for i=1:285903
idx = outidx(i);
TargetAtlas(idx) = voxels(i);
end

%for i=1:285903
%idx = outidx(i);
%TargetAtlas(idx) = voxels(i+97);
%end


TargetAtlas = reshape(TargetAtlas,[91 109 91]);
TargetAtlas(2:91,2:109,2:91) = TargetAtlas(1:90, 1:108, 1:90);
circuit_nii.vol = TargetAtlas;
fname = ['TargetAtlas_' nii_circuit];
save_nifti(circuit_nii,fname);