#Carolyn McNabb 
#August 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.2_fieldmap.sh creates a fieldmap for each ppt and stores in derivatives/fMRI/preprocessed/ppt/fmap folder for that ppt.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}

    echo "Making fmap directory for ${i}"
    mkdir ${derivative_path}/${i}/fmap
    
    echo "Performing brain extraction on magnitude1 image for ${i}"
    bet ${bids_path}/${i}/fmap/${i}_magnitude1.nii.gz ${derivative_path}/${i}/fmap/${i}_magnitude1_brain.nii.gz
    
    echo "Eroding brain extracted magnitude1 image"
    fslmaths ${derivative_path}/${i}/fmap/${i}_magnitude1_brain.nii.gz -ero ${derivative_path}/${i}/fmap/${i}_magnitude1_brain.nii.gz
    
    echo "Copying original magnitude1 image to derivatives folder"
    cp  ${bids_path}/${i}/fmap/${i}_magnitude1.nii.gz ${derivative_path}/${i}/fmap/${i}_magnitude1.nii.gz
    
    echo "Make sure the magnitude1_brain image does not contain any non-brain!!! Erase any voxels as needed and overwrite the file."
    fsleyes ${derivative_path}/${i}/fmap/${i}_magnitude1.nii.gz ${derivative_path}/${i}/fmap/${i}_magnitude1_brain.nii.gz --cmap red-yellow
    

    read -p "Are you happy with the brain extraction for ${i}? (Y/N): " userinput
    echo "Is the brain extraction of magnitude image for ${i} okay?: ${userinput}" >> ${derivative_path}/magnitude_image_checks.txt

    if [ ${userinput} == "Y" ] || [ ${userinput} == "y" ]; then
        echo "creating fmap for ${i}" 
        fsl_prepare_fieldmap SIEMENS ${bids_path}/${i}/fmap/${i}_phasediff.nii.gz ${derivative_path}/${i}/fmap/${i}_magnitude1_brain.nii.gz ${derivative_path}/${i}/fmap/${i}_fieldmap.nii.gz 2.46
        else
        echo "Because you weren't happy with the magnitude brain extraction for ${i}, no fieldmap has been created."
        echo "Because you weren't happy with the magnitude brain extraction for ${i}, no fieldmap has been created." >> ${derivative_path}/magnitude_image_checks.txt
    fi


done