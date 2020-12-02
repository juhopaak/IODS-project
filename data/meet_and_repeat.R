# Juho Pääkkönen
# 2.12.2020
# This is the data wrangling script for Exercise 6
# Data downloaded from https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data

# Set working directory to the data folder
library(here)
data_dir <- paste(here(), "/data", sep="")
setwd(data_dir)

# Read the data from url to csv
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", stringsAsFactors = F, header=T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", stringsAsFactors = F, header=T)

# Write data as csv and check that it can be read again
write.csv(BPRS, "BPRS.csv", row.names=F)
write.csv(RATS, "RATS.csv", row.names=F)
BPRS <- read.csv("BPRS.csv", header=T)
RATS <- read.csv("RATS.csv", header=T)

# Check data variables and structure, and summarize variables
colnames(BPRS)
str(BPRS)
summary(BPRS)

# The BPRS data has 40 observations in 11 variables, which correspond to columns for the treatment and subject number
# and 8 weeks of observation. Each row in the data corresponds to one observation, and the week columns correspond
# to observations at different times. That is, the data is in the wide format. The values of the weekly observations
# vary between the minimum of 18 on week 7 and a maximum of 95 on week 1.

colnames(RATS)
str(RATS)
summary(RATS)

# The rats data have 16 observations and 13 variables, with the first two columns corresponding to subject number
# and observation group of the rats, and the remaining columns to 11 weeks of observations. The observed values
# vary between a minimum of 225 on WD1, that is, week 1, and a maximum of 628 on WD64, that is, week 11.

# Let's convert the categorical variables in the data to factors
BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

# Convert the datasets to long form, and extract data about time in separate columns
library(dplyr)
library(tidyr)

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, 5)))

RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group)
RATSL <- RATSL %>% mutate(Time = as.integer(substr(WD, 3, 4))) 

# Let's take a look at the datasets in long format

colnames(BPRSL)
glimpse(BPRSL)
summary(BPRSL)

# The BPRSL dataset now has 360 rows and 5 columns. The rows now correspond to observations of different
# subjects over time, so we can see that the data include 360 observations in total over dime. 
# the "week" column contains the week number for each individual observation, and the "subject" column
# the number of the observed subject. The "treatment" column shows which treatment was observed in each case,
# and the bprs column shows the measured value for each observation. We can now see from the summary of the
# data that the minimum value of the bprs variable is 18, and the maximum is 95, as we observed before.
# However the summary now concerns all the observations in the data, so we can see that among all observations made,
# the median observed value was 35, and the 3rd quantile 43, so most of the values vary between 18 and 43.
# However, this does not yet tell us anything about how they varied with respect to time.
# The point of the long form is that the observations are now represented in a single column against time,
# so we can do longitudinal analysis.

# We can see the same thing with the RATS data
colnames(RATSL)
glimpse(RATSL)
summary(RATSL)

# We can see from the summary that the first group of rats includes 88 observations in total, while groups
# 2 and 3 include 44 observations each. There are 176 observations in total, and the observed weight of
# the rats vary between 225 and 628 over time.

# Let's write these long format datasets into separate files and see that they can be read

# Write data as csv and check that it can be read again
write.csv(BPRSL, "BPRSL.csv", row.names=F)
write.csv(RATSL, "RATSL.csv", row.names=F)
BPRSL <- read.csv("BPRSL.csv", header=T)
RATSL <- read.csv("RATSL.csv", header=T)

glimpse(BPRSL)
glimpse(RATSL)

# Everything works so we're ready to go.

