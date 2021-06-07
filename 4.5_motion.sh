#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.5_motion.sh will make a file containing the amount of movement in each participant's diffusion MRI and present it as the euclidian distance. Output is stored in the derivatives/TBSS/preprocessed folder

# Data extraction code modified from: Do Tromp, A guide to quantifying head motion in DTI studies,The Winnower 3:e146228.88496 (2016). DOI:10.15200/winn.146228.88496

#!/bin/bash

#set up paths
derivative_path=/storage/shared/research/cinn/2018/GUTMIC/func_diff/derivatives/TBSS/preprocessed

#get subject numbers
cd $derivative_path
subjects=( $(ls -d sub-* )) 

for sub in ${!subjects[@]}; do 
i=${subjects[$sub]}
s=${i//$"sub-"/}


echo "Determining euclidian distance of motion for ${i}"

prefix=`echo "${i}"`
count=`cat $derivative_path/${i}/eddy_corrected_data.eddy_restricted_movement_rms | wc | awk '{print $1}'`
#Average distance from first volume
total=`cat $derivative_path/${i}/eddy_corrected_data.eddy_restricted_movement_rms | tr -d - | awk '{s+=$1} END {print s}'`
average_from_first=`echo "$total / $count" | bc -l`
#Average distance from previous volume
total2=`cat $derivative_path/${i}/eddy_corrected_data.eddy_restricted_movement_rms | tr -d - | awk '{s+=$2} END {print s}'`
average_from_previous=`echo "$total2 / $count" | bc -l`

#now save to a file called dti_motion.txt
echo ${prefix}, ${average_from_first}, ${average_from_previous} >> $derivative_path/dti_motion.txt
done

echo "if you have some extremely high numbers in your list, this will be because there are numbers in the eddy_corrected_data.eddy_restricted_movement_rms files that contain 'e-'. You need to change these numbers to zero to make the script run properly."

echo "values stored in ${derivative_path}/dti_motion.txt"