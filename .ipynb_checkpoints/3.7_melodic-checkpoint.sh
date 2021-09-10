#Carolyn McNabb 
#September 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#3.7_melodic.sh runs FSL's melodic - Melodic will perform ICA on the group as a whole (i.e. all participants at once). It will create components that will be used in the dual regression.
#Key:
#-i = input file
#-o = output directory
#-v = switch on diagnostic messages
#--nobet = no brain extraction
#--bgthreshold = brain/nonbrain threshold - this needs to be on if not performing bet
#tr = 0.72 for the GUTMIC study
#mmthresh = the threshold for mixture modelling
#--dim = number of components you want out
#Ostats produces a folder containing threshold and probability maps.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.


analysis_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/analysis
script_path=/storage/shared/research/cinn/2018/GUTMIC/CM_scripts

echo "MELODIC running - will produce 20 components"
melodic -i ${script_path}/melodic_inputlist.txt -o ${analysis_path}/melodic_components --nobet --bgthreshold=10 --tr=.72 --mmthresh=0.5 –-dim=20


