#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.7_dtifit.sh will correct eddy current-induced distortions and subject movements using FSL's eddy_openmp and store output in the derivatives/TBSS/preprocessed folder for that ppt. It will then copy the FA data from each ppt's folder into the analysis folder and finish by visualising  2D slices from each ppt's data in firefox.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed
analysis_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/analysis

#get subject numbers
cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}

echo "running dtifit on ${i}"
dtifit -k ${derivative_path}/${i}/eddy_corrected_data -m ${derivative_path}/${i}/hifi_b0_brain_mask.nii.gz -r ${derivative_path}/${i}/bvecs -b ${derivative_path}/${i}/bvals -o ${derivative_path}/${i}/${i}_dti

done

#copy the FA data into the analysis folder
for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}

echo "copying FA data for ${i} to analysis folder "
cp ${derivative_path}/${i}/${i}_dti_FA.nii.gz ${analysis_path}

done

#show the dtifit data output in firefox
cd ${analysis_path}
slicesdir  *.nii.gz
firefox slicesdir/index.html

