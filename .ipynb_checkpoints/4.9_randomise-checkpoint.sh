#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.9_randomise.sh will use FSL's randomise function to run nonparametric permutation inference on the TBSS output using the GLM files available in the GLMs directory (created using FSL's Glm tool)

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
stats_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/analysis/stats
GLM_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/GLMs


############# SHANNON
#run randomise to evaluate correlations between FA and shannon index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for Shannon index of diversity"
randomise -i ${stats_path}/all_FA_skeletonised -o ${stats_path}/shannon -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_shannon.mat -t ${GLM_path}/TBSS_shannon.con -n 5000 --T2

#visualise output and print the maximum value in a file called inferential_stats.txt
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm ${stats_path}/mean_FA_skeleton --cmap green --displayRange 0.2 0.8 ${stats_path}/shannon_tfce_corrp_tstat1.nii.gz --cmap red-yellow --displayRange 0.95 1 ${stats_path}/shannon_tfce_corrp_tstat2.nii.gz --cmap blue-lightblue --displayRange 0.95 1 &
echo "Shannon+" `fslstats ${stats_path}/shannon_tfce_corrp_tstat1.nii.gz -R` >> ${stats_path}/inferential_stats.txt
echo "Shannon-" `fslstats ${stats_path}/shannon_tfce_corrp_tstat2.nii.gz -R` >> ${stats_path}/inferential_stats.txt

############# OTUs
#run randomise to evaluate correlations between FA and OTUs index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for OTUs"
randomise -i ${stats_path}/all_FA_skeletonised -o ${stats_path}/otus -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_otus.mat -t ${GLM_path}/TBSS_otus.con -n 5000 --T2

#visualise output and print the maximum value in a file called inferential_stats.txt
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm ${stats_path}/mean_FA_skeleton --cmap green --displayRange 0.2 0.8 ${stats_path}/otus_tfce_corrp_tstat1.nii.gz --cmap red-yellow --displayRange 0.95 1 ${stats_path}/otus_tfce_corrp_tstat2.nii.gz --cmap blue-lightblue --displayRange 0.95 1 &
echo "OTUs+" `fslstats ${stats_path}/otus_tfce_corrp_tstat1.nii.gz -R` >> ${stats_path}/inferential_stats.txt
echo "OTUs-" `fslstats ${stats_path}/otus_tfce_corrp_tstat2.nii.gz -R` >> ${stats_path}/inferential_stats.txt

############# FAITH
#run randomise to evaluate correlations between FA and faith index of diversity – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for faith"
randomise -i ${stats_path}/all_FA_skeletonised -o ${stats_path}/faith -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_faith.mat -t ${GLM_path}/TBSS_faith.con -n 5000 --T2

#visualise output and print the maximum value in a file called inferential_stats.txt
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm ${stats_path}/mean_FA_skeleton --cmap green --displayRange 0.2 0.8 ${stats_path}/faith_tfce_corrp_tstat1.nii.gz --cmap red-yellow --displayRange 0.95 1 ${stats_path}/faith_tfce_corrp_tstat2.nii.gz --cmap blue-lightblue --displayRange 0.95 1 &
echo "Faith+" `fslstats ${stats_path}/faith_tfce_corrp_tstat1.nii.gz -R` >> ${stats_path}/inferential_stats.txt
echo "Faith-" `fslstats ${stats_path}/faith_tfce_corrp_tstat2.nii.gz -R` >> ${stats_path}/inferential_stats.txt

############# AUTISM QUOTIENT
#run randomise to evaluate correlations between FA and Autism Quotient – the T2 option tells FSL that the images are T2 images 
echo "Running randomise for AQ"
randomise -i ${stats_path}/all_FA_skeletonised -o ${stats_path}/aq -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_aq.mat -t ${GLM_path}/TBSS_aq.con -n 5000 --T2

#visualise output and print the maximum value in a file called inferential_stats.txt
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm ${stats_path}/mean_FA_skeleton --cmap green --displayRange 0.2 0.8 ${stats_path}/aq_tfce_corrp_tstat1.nii.gz --cmap red-yellow --displayRange 0.95 1 ${stats_path}/aq_tfce_corrp_tstat2.nii.gz --cmap blue-lightblue --displayRange 0.95 1 &
echo "AQ+" `fslstats ${stats_path}/aq_tfce_corrp_tstat1.nii.gz -R` >> ${stats_path}/inferential_stats.txt
echo "AQ-" `fslstats ${stats_path}/aq_tfce_corrp_tstat2.nii.gz -R` >> ${stats_path}/inferential_stats.txt