#CMcNabb 2021
#data setup for GLM for dti analysis
setwd("/Volumes/GoogleDrive/My Drive/Pilot")
library("Jmisc")
library(dplyr)

#read in demographic, Autism quotient and gut diversity data
pilot_raw <- read.csv("pilot_bacteria_mrs_lcms_GenusLevel.csv", header = TRUE, na.strings=c("N.D"))
LCMS <- pilot_raw[c("age","hand","GABA","Glutamate", "Glutamine")]

# #read in dwi motion data
# motion <- read.delim("G://My Drive/Diffusion/dti_motion.txt", header = F, sep = ",")
# colnames(motion) <- c("sub", "motion_from_1st","motion_from_prev")

#recode handedness from right and left to 0s and 1s
LCMS$hand <- recode(LCMS$hand, Right = 0, Left = 1)

#create dataframes for GLM, including diversity measures/Autism quotient, age, handedness and motion, then demean these values for use in FSL's randomise
LCMS <- demean(LCMS)

# write GLMs to csv format
write.table(LCMS, "GLM_faecalLCMS.csv", sep=",", col.names=FALSE, row.names = FALSE)
