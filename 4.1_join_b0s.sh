#Carolyn McNabb 
#April 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.1_join_B0s.sh will split the dir-up_dwi file and paste B0 volumes together with the dir-down_dwi file to create a new 4D file called b0_images to be stored in the derivatives/TBSS/preprocessed folder for that ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

orig_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

cd $orig_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}
 
echo "Creating b0_images file for ${i}"

fslsplit ${orig_path}/${i}/dwi/${i}_dir-up_dwi.nii.gz ${derivative_path}/${i}/ -t # split the 4D data into separate volumes
fslmerge -t ${derivative_path}/${i}/b0_images.nii.gz ${derivative_path}/${i}/0000.nii.gz ${derivative_path}/${i}/0065.nii.gz ${derivative_path}/${i}/0130.nii.gz ${derivative_path}/${i}/0131.nii.gz ${orig_path}/${i}/dwi/${i}_dir-down_dwi.nii.gz #merge the split b0 volumes and the dir-down image from the main subject folder

rm ${derivative_path}/${i}/0*.nii.gz #delete split volumes from derivatives folder

done