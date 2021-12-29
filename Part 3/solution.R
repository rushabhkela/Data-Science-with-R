# META DATA
# Author : Rushabh Kela
# Topic : Handling Missing Data
# Last Modified : 05-Oct-2021 15:10

# Importing the libraries
library(base)
library(utils)
library(graphics)
library(dplyr)
# Missing Values Libraries
library(naniar)
library(imputeMissings)
library(missForest)

# TASK 1
# Importing the Dataset
# This dataset was created by as a part of Activity 1 (Obtaining data)
# It is a stock market intraday trading dataset with stock prices at intervals of 15 mins
# Source / API : AlphaVantage Stock API
# Since the dataset has more than 21000 rows, I have taken a subset of 3000 rows and uploaded to my github account

data <- read.csv("https://raw.githubusercontent.com/rushabhkela/Data-Science-with-R/main/Part%203/dataset.csv")
data <- as.data.frame(data)
head(data)

# Creating Missing Values in the dataset
# prodNA {missForest}
# 'prodNA' artificially introduces missing values. Entries in the given dataframe are deleted completely at random up to the specified amount.
# Applying the above function to create missing values in the data
# NAs are generated in the columns 4,5,6,7,8 as the other columns do not have numeric data and contain the names, symbols, timestamp at which stock price was recorded
data[4:8] <- prodNA(data[4:8], 0.45)
head(data)

# Looking at the missing data
str(data)
summary(data)

# Visualising the missing data
vis_miss(data)

# As seen from above visualisation, no column in the dataset has more than 60% missing values
# Generating more than 60% missing values in the last column
data[8] <- prodNA(data[8],0.7)

# Also creating some NA rows in the dataset
# Creating a NA vector of 7 elements and replacing it with some rows to create empty rows
NArow <- rep(NA, 7)
NAindex <- sample(1:3000, 10)
data[NAindex, 1:7] <- NArow
vis_miss(data)

# TASK 2
print("Dimensions of the dataset before removing columns/rows")
dim(data)

# Remove the columns/rows having missing data more than 60%
miss_stat <- as.data.frame(miss_var_summary(data))
# Getting columns with pct_miss > 60%
miss_stat <- dplyr::filter(miss_stat, miss_stat$pct_miss > 60)
miss_stat
col <- miss_stat$variable

# Removing the columns
data <- data[!(names(data) %in% col)]
# Removing the rows with missing values > 60%
for(i in 1:nrow(data)) {
    # sum(is.na(data[i,])) will give the number NAs in the row
    # length(data[i,]) will the value 7 (constant, number of elements in the row)
    # Dividing will give the percentage of NA in that particular row, if it is greater than 60% that row is dropped
    if(sum(is.na(data[i,]))/length(data[i,]) > 0.6) {
        data <- slice(data, -c(i))
    }
}

head(data)
print("Dimensions of the dataset after removing columns/rows with more than 60% missing data")
dim(data)

# TASK 3
# Mean or Median Imputation
# Mean Imputation on "Open" Column according to its group (Stock Symbol)
data <- data %>%
    group_by(Stock_Symbol) %>%
    mutate(Open=ifelse(is.na(Open),mean(Open,na.rm=TRUE),Open))

# Median Imputation on "High" according to its group (Stock Symbol)
data <- data %>%
    group_by(Stock_Symbol) %>%
    mutate(High=ifelse(is.na(High),median(High,na.rm=TRUE),High))

data <- as.data.frame(data)
head(data)

# TASK 4
# Standard Algorithm
# I tried Random Forest, kNN (k = 5) on the total dataset
# The normalized RMSE (root mean square error) values were :
# Random Forest : 0.01092781
# kNN : 0.01818699
# imputeR package, Rmse function was used to obtain the above values. Lower the value of RMSE, the better is the fit.
# As noted, random forest algorithm is performing better to fill in the missing values
# I have used the missForest function of the missForest library to carry out this task
# TASK - 5 : (Explanation)
# MissForest is a random forest imputation algorithm for missing data, implemented in R in the missForest() package.
# It initially imputes all missing data using the mean/mode, then for each variable with missing values, MissForest fits a random forest on the observed part and then predicts the missing part.
# This process of training and predicting repeats in an iterative process until a stopping criterion is met, or a maximum number of user-specified iterations is reached.

rf <- missForest(data[4:7])
data[4:7] <- rf$ximp
head(data)

# Advantages of missForest :
# 1. No assumptions required
# 2. Robust to noisy data, as random forests effectively have build-in feature selection.
# 3. Non-parametric: makes no assumptions about the relationship between the features

print("Missing Values in the Dataset Handled.")
View(data)