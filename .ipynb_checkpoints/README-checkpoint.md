# GUTMIC_pilot_analysis
Pipeline will be finalised at a later date - for now, scripts are uploaded as they are written.

CAROLYN MCNABB 2021
GutBrainGABA pre-processing pipeline
**Uses scripts available at https://github.com/CarolynMcNabb/GUTMIC_pilot_analysis.git 

VM setup
1.1. Create Vanilla VM in nutanix https://rrc.reading.ac.uk:9440/console/#login 
1.2. Open VM in NoMachine by pasting IP address from Nutanix
1.3. Open Terminal window
rm -r ~/.mozilla #to clear any open firefox applications

Convert dicoms to BIDS format
N.B. Conversion of diffusion data to BIDS format may later be updated to use ADWI-BIDS https://arxiv.org/pdf/2103.14485.pdf 

BIDS filenames must follow this pattern:
sub-<label>_ses-<label>_task-<label>_acq-<label>_ce-<label>_rec-<label>_dir-<label>_run-<index>_mod-<label>_echo-<index>_flip-<index>_inv-<index>_mt-<label>_part-<label>_recording-<label>
t1_mprage_DC_sag_HCP_256_32ch
MPRAGE structural whole-brain
anat
sub-00x_T1w
Resting_ep2d_bold_p2_s4_32ch_TR1500_2.1x2.1_68_32-head-Coil
Resting state fMRI
func
sub-00x_task-rest_bold
ep2d_diff_mddw_p2_s4_2mm_2avg_32headcoil
Blip up diffusion MRI 
dwi
sub-00x_dir-up_dwi
diff_blip_down_mddw_p2_s4_2mm_2avg_32headcoil
Blip down diffusion MRI
dwi
sub-00x_dir-down_dwi
gre_field_mapping_32ch
Magnitude and phase images (2 files)
fmap
sub-00x_magnitude1
sub-00x_magnitude2
sub-00x_phasediff


2.1. Install python 3 and dcm2bids
In terminal, type:
sudo apt install python3.7
sudo apt install python-pip
pip install dcm2bids

2.2. Set up environment for dcm2bids
sudo apt install gedit
gedit environment.yml 

Paste in the following:

name: dcm2bids
channels:
    - conda-forge
dependencies:
    - dcm2niix
    - dcm2bids
    - pip


Add path:
PATH=$PATH:/opt/anaconda/bin/
export PATH

conda env create -f environment.yml --prefix /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/conda_env/

source activate /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/conda_env
cd /storage/shared/research/cinn/2018/GUTMIC/

2.3. Convert raw data with dcm2bids
Test that dcm2bids is working by typing
dcm2bids --help

Make sure dcm2bids_config.json contains the following:

{
    "descriptions": [
	{
        "dataType": "anat",
        "modalityLabel": "T1w",
        "criteria": {
	"ImageType":  ["ORIGINAL", "PRIMARY", "M", "NORM", "DIS2D"],
	"SequenceName": "*tfl3d1_16ns*",
	"SeriesDescription": "t1_mprage*"
            }
        },
        {
        "dataType": "func",
        "modalityLabel": "bold",
        "customLabels": "task-rest",
        "criteria": {
            "SeriesDescription": "*Resting_ep2d_bold*"
            },
 	"sidecarChanges": {
                "TaskName": "rest"
		}
        },
        {
        "dataType": "fmap",
        "modalityLabel": "magnitude1",
        
        "criteria": {
	"SeriesDescription": "gre_field_mapping_32ch", 		 "SidecarFilename": "*_e1.*"
            },
        "intendedFor": 0
        },
	{
	"dataType": "fmap",
        "modalityLabel": "magnitude2",
        
        "criteria": {
	"SeriesDescription": "gre_field_mapping_32ch", 		 "SidecarFilename": "*_e2.*"
            },
        "intendedFor": 0
        },
        {
        "dataType": "fmap",
        "modalityLabel": "phasediff",
        
        "criteria": {
            "SidecarFilename": "*_e2_ph*"
            },
        "intendedFor": 0
        },
        {
        "dataType": "dwi",
        "modalityLabel": "dwi",
        "customLabels": "dir-up",
        "criteria": {
            "SequenceName": "*ep_b0",
	"ImageType": ["ORIGINAL", "PRIMARY", "DIFFUSION", "NONE", "ND", "NORM", "MOSAIC"],
		"SeriesDescription": "*ep2d_diff*"
            }
        },
        {
        "dataType": "dwi",
        "modalityLabel": "dwi",
        "customLabels": "dir-down",
        "criteria": {
		"SeriesDescription": "*diff_blip_down*"
            }
        }
    ]
}



Then type into terminal (within the conda environment):
0_dcm2bids.sh

Alternatively, type:
cd /storage/shared/research/cinn/2018/GUTMIC/CM_MRS/
dcm2bids -d /storage/shared/research/cinn/2018/GUTMIC/raw/GUTMIC_002/ -p 002 -c /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/code/dcm2bids_config.json 

And Repeat for every subject

TO DO:
Add modality agnostic file (dataset_description.json) https://bids-specification.readthedocs.io/en/stable/03-modality-agnostic-files.html 
Add README file

	
2.4. Validate BIDS format using BIDS validator https://pypi.org/project/bids-validator 
In terminal window (not in python) type:
pip install bids_validator
python3.7 1_validate_bids.py

OR go to https://bids-standard.github.io/bids-validator/ and import bids parent folder (folder containing all subjects)

2.5 Finalise folder structure, including making directories (mkdir) for analysis

/storage/shared/research/cinn/2018/GUTMIC/
   func_diff/
      derivatives/
         TBSS/
            preprocessed/
               sub_001/
               …
             analysis/               
         fMRIprep/
      sub_001/
         anat/
         dwi/
         fmap/
         func/
      sub_002/
         ...




fMRI Preprocessing with fMRIprep
Uses fMRIprep version 20.2.1
Instructions have been borrowed and modified from:
https://github.com/N-HEDGER/NEURO_PYTHON/blob/master/FMRIPREP_SINGULARITY_SLURM/readme.md (Thanks Nick)

First , create a singularity image in docker on Windows PC (after downloading docker)
In Windows command prompt, type:
docker run --privileged -t --rm  -v /var/run/docker.sock:/var/run/docker.sock   -v C:\Users\sa917034\Documents\GitHub\GUTMIC_pilot_analysis:/output   singularityware/docker2singularity     nipreps/fmriprep:20.2.1

Note that the singularity file is huge so a copy has been saved in F:\1_Singularity_fMRIprep (external hard drive) as a back-up. C drive version should be deleted for space purposes after copying to the computing cluster.

Copy the singularity image to the computing cluster:
In Windows command prompt, type:
scp C:\Users\sa917034\Documents\GitHub\GUTMIC_pilot_analysis\nipreps_fmriprep_20.2.1-2020-11-06-c5149417b694.simg sa917034@cluster.act.rdg.ac.uk:/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/Singularity_images


DTI analysis using TBSS
Uses FSL 6.0.1 on an ubuntu MATE 16.04 operating system (8GB)
4.0. FSL prefers bvec and bval files to be named bvecs and bvals for analysis purposes. First step is to link the bval and bvec files in the BIDS folders to the preprocessing directory. In the terminal window, type:
4.0_link_bvs.sh

4.1. Create a file called b0_images.nii.gz - a 4D image file containing eight b=0 volumes that have been acquired using different phase encoding directions (4*P>>A; -j and 4*A>>P; j) so the off-resonance field distortion is different in the different volumes. In the terminal window, type:
4.1_join_b0s.sh

4.2.  Estimate the susceptibility induced off-resonance field using FSL's topup. In the terminal window, type:
4.2_topup.sh
Notes:
an acq_param.txt file for the b0_images, containing the acquisition parameters and readout time, as well as the b02b0.cnf file, and index file are included in the github repository and should be stored in the “code_path” folder

4.3. Generate a brain mask of the non-distorted hifi_b0 image. In terminal window, type:
4.3_mask.sh
	Notes: check each subject’s mask to make sure the automatic brain extraction worked well - lower opacity to view both mask and brain images together..
fsleyes hifi_b0.nii.gz hifi_b0_brain_mask.nii.gz  -cm Yellow
	If the mask does not cover all areas of the brain, try re-creating the mask using:
bet hifi_b0.nii.gz hifi_b0_brain -f 0.4 -m
	-f will make the mask bigger (bet will be less stringent)
	This step was carried out for: sub_008, sub_015

4.4. Perform correction of eddy current-induced distortions and subject movements using FSL's eddy_openmp. In terminal window, type:
4.4_eddy.sh
	Note: slice-to-volume correction was not used for this analysis as it is unavailable with the CPU version of eddy and also is not expected to provide much of an improvement in healthy adult volunteers (such as those used in the current study)
	Manually check each subject’s eddy_corrected_data.nii.gz file using FSL’s fsleyes before proceeding.

4.5. Get mean motion parameters for each participant, including mean motion from first volume and mean motion from previous volume. In the terminal window, type:
4.5_motion.sh

4.6. Extract outlier information and descriptive stats from motion data. These data need to be reported along with any results. See doi: 10.1016/j.neuroimage.2018.02.041 . In R, run the following script:
4.6_outliers.R

4.7. Fit diffusion tensors to the eddy-corrected data. In the terminal window, type:
4.7_dtifit.sh

4.8. Run tract-based spatial statistics on the data. In the terminal window, type:
4.8_TBSS.sh
	Notes: this script runs several different commands and requires user interaction to move onto the next stage of analysis. Read the instructions in the terminal and respond when requested.



