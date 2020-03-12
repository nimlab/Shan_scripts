#!/bin/tcsh

#SYNTAX:
#CiftiCreator.csh (filename)
#Filename = MLP_output/(path)

set imgfile = $1
set interp = $2
#set outfile = $2
#set MLPdir = $2
#set fslr = $3
#set inflation = $4
#set nii = $2
#mkdir ../MLP_output/Surface/{$sub}

set filename = $imgfile:r:r
set outfile = $filename


wb_command -volume-to-surface-mapping ${filename}.nii.gz ~/Templates/Q1-Q6_R440.R.midthickness.32k_fs_LR.surf.gii {$outfile}_R.func.gii -enclosing

wb_command -volume-to-surface-mapping ${filename}.nii.gz ~/Templates/Q1-Q6_R440.L.midthickness.32k_fs_LR.surf.gii {$outfile}_L.func.gii -enclosing

wb_command -cifti-create-dense-timeseries {$outfile}.dtseries.nii -volume ${filename}.nii.gz ~/scripts/PetersenScripts/Resources/subcortical_mask_LR_333.nii -left-metric {$outfile}_L.func.gii -right-metric {$outfile}_R.func.gii

end
