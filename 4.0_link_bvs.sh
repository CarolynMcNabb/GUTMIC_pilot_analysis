#Carolyn McNabb 
#April 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.0_link_bvs.sh will link the bvec and bval files in each participant's folder to bvecs and bvals in the derivatives/TBSS/preprocessed folder for that ppt

#!/bin/bash

orig_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff
link_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

cd $orig_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}
 
echo "Linking bvec and bval file for ${i}"

mkdir ${link_path}/${i} #make a directory for the subject
ln ${orig_path}/${i}/dwi/${i}_dir-up_dwi.bval ${link_path}/${i}/bvals #link bvals
ln ${orig_path}/${i}/dwi/${i}_dir-up_dwi.bvec ${link_path}/${i}/bvecs #link bvecs

done