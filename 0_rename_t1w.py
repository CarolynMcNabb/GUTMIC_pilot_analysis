"""
Carolyn McNabb 
April 2020
GUTMIC BRAIN DATA PILOT ANALYSIS 
0_rename_t1w.py will rename the files in the anat folders to include "T1w" before the .nii.gz extension
"""
#import modules
import os


#set up path to folders containing BIDS formatted data
BIDS_dir = ("/storage/shared/research/cinn/2018/GUTMIC/func_diff/") 

# for every subject in the above folder, go into anat folder and add T1w to file name
for d in os.listdir(path = BIDS_dir):
    if "sub" in d:
        print(d)
        orig_nii = "/anat/"+d+"_rec-NORM_.nii.gz"
        new_nii = "/anat/"+d+"_rec-NORM_T1w.nii.gz"
        orig_json = "/anat/"+d+"_rec-NORM_.json" 
        new_json = "/anat/"+d+"_rec-NORM_T1w.json"
        os.rename(BIDS_dir+d+orig_nii,
                  BIDS_dir+d+new_nii)
        os.rename(BIDS_dir+d+orig_json,
                  BIDS_dir+d+new_json)
        

print( "anat data files renamed" )