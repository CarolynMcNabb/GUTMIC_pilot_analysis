#Carolyn McNabb 
#June 2021
#GUTMIC BRAIN DATA PILOT ANALYSIS 
#4.6_outliers.R will identify any outliers in the motion data and 
#provide descriptive statistics of motion parameters for reporting with results

#copy the data into a folder you have access to and set the path
setwd("G://My Drive/Diffusion/")

#load motion data
motion <- read.delim("dti_motion.txt", header = F, sep = ",")
#remame columns
colnames(motion) <- c("sub", "motion_from_1st","motion_from_prev")
library(dplyr)
library(tidyr)
library(ggplot2)
library(psych)


#create function to identify outliers:
is_outlier <- function(x) {
  return(x < quantile(x, 0.25) - 1.5 * IQR(x) | x > quantile(x, 0.75) + 1.5 * IQR(x))
} 
#identify outliers  
motion$sub[which(is_outlier(motion$motion_from_1st))]
motion$sub[which(is_outlier(motion$motion_from_prev))]  
    
#gather data 
motion <- gather(motion, motion_type, motion_mm, 2:3, factor_key=TRUE)

#create labels for outliers and plot them as boxplots using ggplot
motion %>%
  group_by(motion_type) %>%
  mutate(outlier = ifelse(is_outlier(motion_mm), sub, as.numeric(NA))) %>%

ggplot(., aes(y=motion_mm,x=factor(motion_type))) + 
  geom_boxplot(outlier.colour = "#4539AC") +
  geom_text(aes(label=outlier),na.rm=TRUE,nudge_y=0.05) + 
  theme_classic() +
  xlab("Motion type") +
  ylab("Motion (mm)")

#get descriptive stats of motion parameters
describeBy(motion,motion$motion_type)

