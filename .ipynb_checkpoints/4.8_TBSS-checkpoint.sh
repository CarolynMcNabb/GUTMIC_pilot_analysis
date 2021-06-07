#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.8_TBSS.sh will perform the different stages of tract-based spatial statistics using FSL's TBSS pipeline.

#!/bin/bash

module load fsl6.0 #load fsl - if you are using a machine other than the virtual machine at University of Reading, you can comment out this line.

#set up paths
analysis_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/analysis

#change directory into the analysis folder (where all ppts' FA data are currently stored)
cd ${analysis_path}

#The tbss_1_preproc script places its output in a newly-created sub-directory called FA. It will also create a sub-directory called origdata and place all your original images in there for posterity.
#tbss_1_preproc *.nii.gz

#view the output to make sure it is okay
#firefox ${analysis_path}/FA/slicesdir/index.html &

#ask for user input before moving to next stage of analysis
echo "Are you happy to proceed with the analaysis? [y,n]"
read input
if [[ ${input} == "Y" || ${input} == "y" ]]; then
        echo "Great, moving onto tbss_2_reg"
else
        echo "Analysis stopped after tbss_1_preproc"
        exit
fi

# tbss_2_reg runs the nonlinear registration, aligning all the FA data across subjects. The recommended approach is to align every FA image to the FMRIB58_FA template (option –T).
echo "Running tbss step 2"
tbss_2_reg -T

echo "Are you happy to proceed with the analaysis? [y,n]"
read input
if [[ ${input} == "Y" || ${input} == "y" ]]; then
        echo "Great, moving onto tbss_3_postreg"
else
        echo "Analysis stopped after tbss_2_reg"
        exit
fi

#for tbss_3_postreg, use the –S option – this derives the mean FA and skeleton from the actual subjects you have rather than using the FMRIB58_FA template. The script then takes the target and affine-aligns it into 1x1x1mm MNI152 space... –S option is recommended by fsl(see https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1406&L=FSL&P=R158142&1=FSL&9=A&J=on&d=No+Match%3BMatch%3BMatches&z=4)
echo "Running tbss step 3"
tbss_3_postreg -S

#make sure the threshold of 0.2 is appropriate for the mean skeleton. If not, it will need to be adjusted.
fsleyes ${analysis_path}/stats/all_FA -b 0,0.8 ${analysis_path}/stats/mean_FA_skeleton -b 0.2,0.8 -l Green &

#ask for user input before moving to next stage of analysis
echo "Is the threshold of 0.2 appropriate for the mean skeleton? If the registration has worked well you should see that in general each subject's major tracts are reasonably well aligned to the relevant parts of the skeleton. If you are happy to use 0.2, just type y, otherwise, type the new threshold:"
read input
if [[ ${input} == "Y" || ${input} == "y" ]]; then
        echo "Using threshold of 0.2 for skeleton"
        tbss_4_prestats 0.2
        #store threshold in a file called thresh.txt
        echo "Threshold used for tbss_4_prestats was 0.2" >> ${analysis_path}/thresh.txt
else
        echo "Using user-defined threshold of ${input}"
        tbss_4_prestats ${input}
        #store threshold in a file called thresh.txt
        echo "Threshold used for tbss_4_prestats was ${input}" >> ${analysis_path}/thresh.txt
fi

