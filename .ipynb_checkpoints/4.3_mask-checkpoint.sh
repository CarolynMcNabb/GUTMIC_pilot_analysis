#Carolyn McNabb 
#May 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.3_mask.sh generates a brain mask of the non-distorted hifi_b0 image and stores output in derivatives/TBSS/preprocessed folder for that ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}
 
echo "Creating brain mask for ${i}"
#get mean across volumes of hifi image
fslmaths ${derivative_path}/${i}/hifi_b0.nii.gz -Tmean ${derivative_path}/${i}/hifi_b0.nii.gz
#brain extraction using bet (mask created using -m)
bet ${derivative_path}/${i}/hifi_b0.nii.gz ${derivative_path}/${i}/hifi_b0_brain -m


done