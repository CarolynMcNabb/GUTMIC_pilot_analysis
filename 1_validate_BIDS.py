"""
Carolyn McNabb 
April 2021
GUTMIC BRAIN DATA PILOT ANALYSIS 
1_validate_BIDS.py will go into every subject folder in the func_diff directory and determine whether the filenames adhere to BIDS naming conventions.

"""
from bids_validator import BIDSValidator
import os


#set up path to folders containing BIDS formatted data
BIDS_dir = ("/storage/shared/research/cinn/2018/GUTMIC/func_diff/") 
BIDS_folders = ("anat","func","dwi","fmap")
ses = "ses-1"

# for every subject in the above folder, go into each folder (anat, func, dwi and fmap) and determine if the names of files adhere to BIDS naming rules 
for d in os.listdir(path = BIDS_dir):
    if "sub" in d:
        for folder in BIDS_folders:
            print("Checking files in", folder, " directory...")
            for file in os.listdir(os.path.join(BIDS_dir,d,ses,folder)):
                print("Is", file, "in BIDS format?")
                full_file_path = os.path.join(BIDS_dir,d,ses,folder,file)
                print(BIDSValidator().is_bids(full_file_path))
                print(full_file_path)
                
