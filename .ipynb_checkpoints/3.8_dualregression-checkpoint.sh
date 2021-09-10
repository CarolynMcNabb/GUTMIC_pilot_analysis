#Carolyn McNabb 
#September 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.8_dualregression.sh runs FSL's dual regression using the group-level independent components created with MELODIC
#Usage: dual_regression <group_IC_maps> <des_norm> <design.mat> <design.con> <n_perm> <output_directory> <input1> <input2> <input3>

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


analysis_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/analysis
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts

echo "Running dual regression for GUTMIC data"
melodic -i ${script_path}/melodic_inputlist.txt -o ${analysis_path}/melodic_components --nobet --bgthreshold=10 --tr=.72 --mmthresh=0.5 –-dim=20


dual_regression ${analysis_path}/melodic_components 1 ${script_path}/ICA_LCMS.mat ${script_path}/ICA_LCMS.con 5000 ${analysis_path}/dual_regression.DR `cat ${script_path}/melodic_inputlist.txt`