## fMRI Preprocessing with fMRIprep
Note to self - these intstructions result in an error when trying 
```
import templateflow.api as api
```
After that, I haven't managed to make it work.


Uses fMRIprep version 20.2.1
Instructions have been borrowed and modified from:
https://github.com/N-HEDGER/NEURO_PYTHON/blob/master/FMRIPREP_SINGULARITY_SLURM/readme.md (Thanks Nick)

First , create a singularity image in docker on Windows PC (after downloading docker)
In Windows command prompt, type:
```
docker run --privileged -t --rm  -v /var/run/docker.sock:/var/run/docker.sock   -v C:\Users\sa917034\Documents\GitHub\GUTMIC_pilot_analysis:/output   singularityware/docker2singularity     nipreps/fmriprep:20.2.1
```
Note that the singularity file is huge so a copy has been saved in F:\1_Singularity_fMRIprep (external hard drive) as a back-up. C drive version should be deleted for space purposes after copying to the computing cluster.

Copy the singularity image to the computing cluster:
In Windows command prompt, type:
```
scp C:\Users\sa917034\Documents\GitHub\GUTMIC_pilot_analysis\nipreps_fmriprep_20.2.1-2020-11-06-c5149417b694.simg sa917034@cluster.act.rdg.ac.uk:/storage/shared/research/cinn/2018/GUTMIC/CM_scripts/Singularity_images
```

Open a terminal in VM and ssh into the Reading Academic Computing Cluster (RACC). In terminal window, type:
```
ssh -Y sa917034@cluster.act.rdg.ac.uk
```
Notes: The flag ‘-Y’ might be needed to enable X11 forwarding, to allow running GUI applications. 


Load Anaconda and then create a new environment (called fmriprep_env) containing python 3.5. After this, install templateflow into this environment so that fMRIprep can access all the neuroimaging tools it needs to run. In the terminal window (which is now pointing to the RACC), type:
module load anaconda
```
cd /storage/shared/research/cinn/2018/GUTMIC/CM_scripts/
conda create -n fmriprep_env python=3.5 anaconda
source activate fmriprep_env
pip install templateflow
```

Import relevant templates, including the OASIS30ANTs template, which fmriprep uses as part of its workflow and MNI template. Include anything that is listed under 'output_spaces' in your call to fmriprep. In the terminal window, type:
```
python
import templateflow.api as api
api.get(['MNI152NLin2009cAsym', 'OASIS30ANTs', 'fsaverage’])
```