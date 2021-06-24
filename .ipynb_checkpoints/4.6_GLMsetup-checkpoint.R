#CMcNabb 2021
#data setup for GLM for dti analysis
setwd("G:/My Drive/Pilot")
library("Jmisc")
library(dplyr)

#read in demographic, Autism quotient and gut diversity data
pilot_raw <- read.csv("pilot_bacteria_mrs_lcms_GenusLevel.csv")
diversity <- pilot_raw[c("age","hand","faith_pd","shannon","observed_otus", "aq")]

#read in dwi motion data
motion <- read.delim("G://My Drive/Diffusion/dti_motion.txt", header = F, sep = ",")
colnames(motion) <- c("sub", "motion_from_1st","motion_from_prev")

#recode handedness from right and left to 0s and 1s
diversity$hand <- recode(diversity$hand, Right = 0, Left = 1)

#create dataframes for GLM, including diversity measures/Autism quotient, age, handedness and motion, then demean these values for use in FSL's randomise
shannon_GLM <- demean(cbind(diversity$shannon, diversity$age, diversity$hand, motion$motion_from_1st, motion$motion_from_prev))
otus_GLM <- demean(cbind(diversity$observed_otus, diversity$age, diversity$hand, motion$motion_from_1st, motion$motion_from_prev))
faith_GLM <- demean(cbind(diversity$faith_pd, diversity$age, diversity$hand, motion$motion_from_1st, motion$motion_from_prev))
aq_GLM <- demean(cbind(diversity$aq, diversity$age, diversity$hand, motion$motion_from_1st, motion$motion_from_prev))

# write GLMs to csv format
write.table( shannon_GLM, "GLMshannon.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( otus_GLM, "GLMotus.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( faith_GLM, "GLMfaith.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( aq_GLM, "GLMaq.csv", sep=",", col.names=FALSE, row.names = FALSE)