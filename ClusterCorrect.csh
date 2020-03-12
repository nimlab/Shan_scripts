#!/bin/tcsh

#Creates thresholded cluster-corrected image. Inputs:
#   1. Fileroot is the root of the nii filename
#   2. Thresh is the z-threshold that the image must survive
#   3. Extent is the cluster extent threshold

set fileroot = $1
set thresh = $2
set extent = $3

fslmaths $fileroot -mul -1 ${fileroot}_inv

foreach nii ($fileroot ${fileroot}_inv)
	cluster -i $nii -t $thresh --mm --minextent=${extent} --othresh=${nii}_clus
end

fslmaths ${fileroot}_inv_clus -mul -1 ${fileroot}_inv_clus
fslmaths ${fileroot}_clus -add ${fileroot}_inv_clus ${fileroot}_Cluster

rm ${fileroot}_inv* ${fileroot}_inv_clus* ${fileroot}_clus*

