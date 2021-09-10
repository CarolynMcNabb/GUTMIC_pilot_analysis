#Carolyn McNabb 
#September 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.9_randomise.sh will use FSL's randomise function to run nonparametric permutation inference on the dual regression output using the GLM files available in the GLMs directory (created using FSL's Glm tool)

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
analysis_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/analysis
GLM_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/GLMs

#run randomise to evaluate correlations between ICA components and GABA, Glutamate and Glutamine levels from LCMS
echo "Running randomise for GUTMIC data"
randomise -i ${stats_path}/all_FA_skeletonised -o ${stats_path}/shannon -m ${stats_path}/mean_FA_skeleton_mask -d ${GLM_path}/TBSS_shannon.mat -t ${GLM_path}/TBSS_shannon.con -n 5000 --T2




derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts

cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
    i=${subjects[$sub]}
    s=${i//$"sub-"/}


randomise -i ${analysis_path}/dr_stage2 -o randomise_ftest_ic${i} -d design.mat -t design.con -f ../GLM_eigen_Ftest.fts -n 5000 -D -T -x

done

#visualise output and print the maximum value in a file called inferential_stats.txt
fsleyes $FSLDIR/data/standard/MNI152_T1_1mm ${stats_path}/mean_FA_skeleton --cmap green --displayRange 0.2 0.8 ${stats_path}/shannon_tfce_corrp_tstat1.nii.gz --cmap red-yellow --displayRange 0.95 1 ${stats_path}/shannon_tfce_corrp_tstat2.nii.gz --cmap blue-lightblue --displayRange 0.95 1 &
echo "Shannon+" `fslstats ${stats_path}/shannon_tfce_corrp_tstat1.nii.gz -R` >> ${stats_path}/inferential_stats.txt
echo "Shannon-" `fslstats ${stats_path}/shannon_tfce_corrp_tstat2.nii.gz -R` >> ${stats_path}/inferential_stats.txt