"""
Carolyn McNabb 2021
This script will make the directories for the fMRI data within the BIDs derivatives directory

"""

import os
import pathlib
#import string

#path to mrs data on shared drive
bids_path = "/Volumes/gold/cinn/2018/GUTMIC/func_diff"
dest_path = "/Volumes/gold/cinn/2018/GUTMIC/func_diff/derivatives/fMRI/preprocessed"

#change directory to mrs data folder
os.chdir(path = bids_path)

#get content of bids data folder, if the directory starts with sub (i.e. is a subject's directory),  then do the following...
with os.scandir(".") as dir:
    for sub in dir:
        if sub.name.startswith('sub') :
            print(sub.name) 
            #create pathname for subject
            newdir = pathlib.Path(os.path.join(dest_path,sub.name))
            #create the new folders only if they don't already exist. Do not overwrite any files already contained within folders
            newdir.mkdir(parents=True, exist_ok=True)
            print(newdir)
               
            #move up to mrs directory and begin again
            os.chdir(path = bids_path)

            

os.chdir("/Volumes/GoogleDrive/My Drive/GitHub/GUTMIC_pilot_analysis")
