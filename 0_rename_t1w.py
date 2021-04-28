"""
Carolyn McNabb 
April 2021
GUTMIC BRAIN DATA PILOT ANALYSIS 
0_rename_t1w.py will rename the files in the anat folders to include "T1w" before the .nii.gz extension
"""
#import modules
import os
import fileinput

#create a function called replace_in_file that will replace the text in a file with new text
def replace_in_file(file_path, search_text, new_text):
    with fileinput.input(file_path, inplace=True) as f:
        for line in f:
            new_line = line.replace(search_text, new_text)
            print(new_line, end='')
            
            
#set up path to folders containing BIDS formatted data
BIDS_dir = ("/storage/shared/research/cinn/2018/GUTMIC/func_diff/") 

# for every subject in the above folder, go into anat folder and add T1w to file name
for d in os.listdir(path = BIDS_dir):
    if "sub" in d:
        print(d) #which subject is being worked on
        orig_nii = "/anat/"+d+"_rec-NORM_.nii.gz" #orig nii filename 
        new_nii = "/anat/"+d+"_rec-NORM_T1w.nii.gz" #new nii filename
        orig_json = "/anat/"+d+"_rec-NORM_.json" #orig json filename
        new_json = "/anat/"+d+"_rec-NORM_T1w.json" #new json filename
        os.rename(BIDS_dir+d+orig_nii,
                  BIDS_dir+d+new_nii) #rename .nii file
        os.rename(BIDS_dir+d+orig_json,
                  BIDS_dir+d+new_json) #rename .json file
        
        #update the subject scans.tsv file with the new filename
        file_path = BIDS_dir+d+"/"+d+"_scans.tsv"
        replace_in_file(file_path, "rec-NORM_.nii.gz", "rec-NORM_T1w.nii.gz") 
        
        

print( "anat data files renamed" )