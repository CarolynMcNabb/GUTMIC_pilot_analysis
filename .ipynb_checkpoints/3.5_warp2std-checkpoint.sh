#Carolyn McNabb 
#September 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.5_warp2std.sh warps filtered_func_data into standard space. Output is stored in derivatives/fMRI/preprocessed/ppt/func folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts

cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}

    echo "Warping filtered_func_data to standard space for ${i}"
    applywarp -r ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/reg/standard.nii.gz  -i ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/filtered_func_data.nii.gz -o ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard -w ${derivative_path}/${i}/func/${i}_FEATpreproc.feat/reg/highres2standard_warp.nii.gz --premat=${derivative_path}/${i}/func/${i}_FEATpreproc.feat/reg/example_func2highres.mat 
    echo "${derivative_path}/${i}/func/${i}_FEATpreproc.feat/${i}_filtered_func_standard.nii.gz" >> ${script_path}/melodic_inputlist.txt

done

