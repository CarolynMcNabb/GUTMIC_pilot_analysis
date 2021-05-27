#Carolyn McNabb 
#May 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.2_topup.sh will estimate the susceptibility induced off-resonance field using FSL's topup and store output in derivatives/TBSS/preprocessed folder for that ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

code_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}
 
echo "Estimating susceptibilty induced distortion for ${i} using FSL's topup"
topup --imain=${derivative_path}/${i}/b0_images.nii.gz --datain=${code_path}/acq_param.txt --config=${code_path}/b02b0.cnf --out=${derivative_path}/${i}/topup_output --iout=${derivative_path}/${i}/hifi_b0

done