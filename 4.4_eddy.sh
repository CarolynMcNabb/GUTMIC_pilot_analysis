#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.4_eddy.sh will correct eddy current-induced distortions and subject movements using FSL's eddy_openmp and store output in the derivatives/TBSS/preprocessed folder for that ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
orig_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff
code_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

#get subject numbers
cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}

#eddy current correction
echo "Correcting eddy current-induced distortions and subject movements for ${i} using FSL's eddy"
eddy_openmp --imain=${orig_path}/${i}/dwi/${i}_dir-up_dwi.nii.gz --mask=${derivative_path}/${i}/hifi_b0_brain_mask --acqp=${code_path}/acq_param.txt --index=${code_path}/index.txt --bvecs=${derivative_path}/${i}/bvecs --bvals=${derivative_path}/${i}/bvals --topup=${derivative_path}/${i}/topup_output --ol_type=both --mb=4 --repol --out=${derivative_path}/${i}/eddy_corrected_data 

done