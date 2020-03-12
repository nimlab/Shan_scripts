#!/bin/csh
# note, to run this you have to type the following:
# source make_sphere_roi.sh <input_image.nii.gz> <x y z> <mm>
# 		<input image> is an image that has the same resolution as the image you want to apply the ROI to.
#				NOTE: this image either has to be in the folder you are launching the command from, or has to have a full path.
#		<x y z> are the ROI coordinates
#		<mm>  is the width of the ROI. If you will always want it to be the same (say 10mm), then you can just delete the $5
#				in the line starting with "echo", and replace the '$5' in the last line with the number you want (e.g. 10).
#
#	Script by Martin M Monti (monti@psych.ucla.edu)

fslmaths ${FSLDIR}/data/standard/MNI152lin_2mm_brain.nii.gz -roi $2 1 $3 1 $4 1 0 1 tmp
fslmaths tmp -kernel sphere $1 -fmean -bin $5 -odt float
rm tmp