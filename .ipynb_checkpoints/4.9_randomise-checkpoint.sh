#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.9_randomise.sh will use FSL's randomise function to run nonparametric permutation inference on the TBSS output using the GLM files available in the GLMs directory (created using FSL's Glm tool)

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
stats_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/analysis/stats
GLM_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/GLMs



#run randomise to evaluate correlations between FA and shannon index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for Shannon index of diversity"
randomise -i ${stats_path}/all_FA_skeletonised -o tbss -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_shannon.mat -t ${GLM_path}/TBSS_shannon.con -n 500 --T2

#run randomise to evaluate correlations between FA and shannon index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for OTUs"
randomise -i ${stats_path}/all_FA_skeletonised -o tbss -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_otus.mat -t ${GLM_path}/TBSS_otus.con -n 500 --T2

#run randomise to evaluate correlations between FA and shannon index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for faith"
randomise -i ${stats_path}/all_FA_skeletonised -o tbss -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_faith.mat -t ${GLM_path}/TBSS_faith.con -n 500 --T2