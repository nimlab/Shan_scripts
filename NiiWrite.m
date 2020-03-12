function unmask = NiiWrite(mat,filename,UnmaskOnly)

%Unmask and write a nifti

load('C:\Users\Shan Siddiqi\Documents\Research\MatlabWorkspaces\Active\ROIs.mat','NiiMask','V');
addpath(genpath('C:\Users\Shan Siddiqi\Documents\Research\neuroimaging tools\MatlabTFCE\'));
s = size(mat,2);

unmask = zeros(902629,s);
unmask(find(NiiMask),:)=mat;

if UnmaskOnly<1
if s>1
    V.img = reshape(unmask,[91 109 91 s]);
else 
    V.img = reshape(unmask,[91 109 91]);
end

save_nii(V,filename);

else
    unmask = reshape(unmask,[91 109 91]);

end