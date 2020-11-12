# Juho Pääkkönen
# 12.11.2020
# This is the data wrangling script for Exercise 3
# Data downloaded from https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Set working directory to the data folder
library(here)
data_dir <- paste(here(), "/data", sep="")
setwd(data_dir)

# Read data
mat <- read.table("student-mat.csv", header=TRUE, sep=";")
por <- read.table("student-por.csv", header=TRUE, sep=";")

# Explore dimensions and structure of the data
dim(mat)
dim(por)
str(mat)
str(por)

# The mat dataset includes 395 observations and 33 variables.
# The por dataset includes 649 observations and 33 variables.
# 16 of the variables are numeric, the rest are factors.

# Join the datasets using inner_join from the dplyr package
library(dplyr)

# Common columns to join the data by
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# Inner join the datasets to keep only students who answered questions in both data
mat_por <- inner_join(mat, por, by = join_by, suffix = c(".mat", ".por"))

# Explore dimensions and structure of the new dataset
dim(mat_por)
str(mat_por)

# The dataset now has 382 observations and 53 variables

# Create a new data frame with only the joined columns
alc <- select(mat_por, one_of(join_by))

# Get the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# Iterate over the columns that were not used for joining, and remove duplicates
# in the new dataset
for(column_name in notjoined_columns) {
  # select two columns from 'mat_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Check dimensions and structure of the resulting combined dataset
dim(alc)
str(alc)

# Data has 382 observations and 33 variables, as it should
# 16 of the variables are numeric, and the rest are factors, as before
# Everything seems to be OK

# Create new column alc_use by averaging over weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse at the data
glimpse(alc)

# Everything seems to be in order, the data has 382 observations and 35 variables,
# with the new variables added

# Let's write the final dataset as csv and do a test that can be read
write.csv(alc, "alc.csv", row.names=FALSE)

alc <- read.csv("alc.csv", header=TRUE)

glimpse(alc)

# Seems to work