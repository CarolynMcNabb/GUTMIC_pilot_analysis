#Carolyn McNabb 
#August 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.3_FEATpreproc.sh modifies the parent file FEATpreproc.fsf to create a subject specific preprocessing file and runs this through FEAT. Output is stored in derivatives/fMRI/preprocessed/ppt/func folder for each ppt

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

bids_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed
#create a directory to put the FEATpreproc files into
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts
mkdir ${script_path}/FEATpreproc

cd $bids_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}

    echo "Making func directory for ${i}"
    mkdir ${derivative_path}/${i}/func
    
    #get number of volumes for resting state scan - in case this differs between subjects
    vols=`fslinfo ${bids_path}/${i}/func/${i}_task-rest_bold.nii.gz | grep "^dim4" | awk '{print $2}'`
    echo "Number of volumes for ${i} is ${vols}"
    
    echo "Modifying FEATpreproc.fsf file and saving in ${script_path}/FEATpreproc directory"
    sed -e "s/sub-ID/${i}/g" -e "s/num_vols/${vols}/g" <${script_path}/FEATpreproc.fsf >${script_path}/FEATpreproc/${i}_FEATpreproc.fsf
    
    echo "Running feat for ${i}"
    feat ${script_path}/FEATpreproc/${i}_FEATpreproc.fsf
    
done