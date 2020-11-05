# Juho Pääkkönen
# 5.11.2020
# This is the data wrangling script for Exercise 2

# Read data directly from url
lrn14 <- read.table(url("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt"), header=TRUE, sep="\t")

# Explore dimensions and structure
dim(lrn14)
str(lrn14)

# The dataset includes 183 observations and 60 variables.
# 59 of the variables are integer valued, while the gender variable is a factor.

# Scale the attitude column to 1-5 scale
lrn14$attitude <- lrn14$Attitude / 10

# Select the columns related to deep, surface and strategic learning and create new columns by averaging
library(dplyr)

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_cols <- select(lrn14, any_of(deep_questions))
surf_cols <- select(lrn14, any_of(surf_questions))
stra_cols <- select(lrn14, any_of(stra_questions))

lrn14$deep <- rowMeans(deep_cols)
lrn14$surf <- rowMeans(surf_cols)
lrn14$stra <- rowMeans(stra_cols)

# Select columns for the analysis dataset
lrn14_sub <- select(lrn14, any_of(c("gender","Age","attitude", "deep", "stra", "surf", "Points")))

# Drop rows with zero value in the Points variable
lrn14_sub <- lrn14_sub[lrn14_sub$Points != 0,]

# Examine data structure
str(lrn14_sub)

# Data contains 166 observations and 7 variables

# Set working directory to the data folder
library(here)
data_dir <- paste(here(), "/data", sep="")
setwd(data_dir)

# Write analysis dataset to csv and test that it can be read
write.csv(lrn14_sub, "lrn14.csv", row.names=FALSE)
lrn14 <- read.csv("lrn14.csv", header=TRUE)

str(lrn14)
head(lrn14)

# Seems to work