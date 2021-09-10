#Carolyn McNabb 
#September 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.6_smoothdownsample.sh will smooth the standardised fmri resting state data using a Gaussian kernel and FWHM 5 mm and then downsample to a 2 mm voxel size so that melodic runs quicker.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts

cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}

    echo "Smoothing standardised filtered func data for ${i}"
    #-s <sigma> : creates a gauss kernel of sigma mm and performs mean filtering
   fslmaths ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard.nii.gz -s 2.1233226 ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard_smooth.nii.gz
   echo "Downsampling smoothed standardised filtered func data for ${i}"
  flirt -interp nearestneighbour -in ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard_smooth.nii.gz -ref ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/reg/standard.nii.gz -applyisoxfm 2 -out ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard_smooth_2mm.nii.gz
   
    echo "${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard_smooth_2mm.nii.gz" >> ${script_path}/melodic_inputlist.txt
    
    echo "Deleting ${i}_filtered_func_standard.nii.gz & ${i}_filtered_func_standard_smooth.nii.gz"
    rm ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard.nii.gz
    rm ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard_smooth.nii.gz

done

