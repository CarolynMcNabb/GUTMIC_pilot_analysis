#Carolyn McNabb 
#April 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#2.0_dcm2bids.sh will run dcm2bids to convert all dicom images in the raw data file into BIDS formatted nifti images

#!/bin/bash

raw_path=/storage/shared/research/cinn/2018/GUTMIC/raw
code_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/code
data_dir=/storage/shared/research/cinn/2018/GUTMIC/func_diff

cd $raw_path
subjects=( $(ls -d GUTMIC_* )) 

cd $data_dir
for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"GUTMIC_"/}
 
echo "Converting dicom data for ${i} to BIDS"

dcm2bids -d ${raw_path}/${i}/ -p ${s} -c ${code_path}/dcm2bids_config.json 

done