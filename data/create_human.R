# Juho Pääkkönen
# 19.11.2020
# This is the data wrangling script for Exercise 5
# Data downloaded from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/

# Set working directory to the data folder
library(here)
data_dir <- paste(here(), "/data", sep="")
setwd(data_dir)

# Read the data from url to csv
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# See the dimensions and structure of the datasets
dim(hd)
str(hd)
dim(gii)
str(gii)

# The hd dataset has 195 observations in 8 variables. Two of the variables are character valued, the rest are numeric
# The gii dataset has 195 observations in 10 variables. One of these is character valued and the rest numeric.

# Create summaries of the variables in the datasets
summary(hd)
summary(gii)

# Rename the variables in the data with shorter names
colnames(hd) <- c("hdi_rank", "country", "hdi", "life_expect", "edu_expect", "edu_mean", "gni", "gni_hdi")
colnames(gii) <- c("gii_rank", "country", "gii", "maternal_mortality", "adol_br", "repr_percept", "f_education", "m_education", "f_participation", "m_participation")

library(dplyr)

# Mutate the gii data to create new columns for the ratio of Female and Male
# populations with secondary education, and the ratio of labour force participation of females
gii <- mutate(gii, edu_ratio = f_education / m_education)
gii <- mutate(gii, part_ration = f_participation / m_participation)

# Combine the data by country using inner join, to keep only countries in both datasets
human_data <- inner_join(hd, gii, by = c("country"))

# Glimpse at the data to see that everything is as it should be
glimpse(human_data)

# The dataset now has 195 rows and 19 columns, as it was supposed to

# Save the data and reread it to see that everything works
write.csv(human_data, "human.csv", row.names=FALSE)

human <- read.csv("human.csv", header=TRUE)

glimpse(human)

# Seems to work
