# META DATA
# Author : Rushabh Kela
# Topic : Statistical Methods for Data Science
# Last Modified : 18-Oct-2021 15:16 

# Importing the libraries
library(base)
library(utils)
library(graphics)
library(dplyr)
library(stats)
library(modeest)

# Reading the Dataset
data <- read.csv("https://raw.githubusercontent.com/rushabhkela/Data-Science-with-R/main/Part%201/StockData.csv")
head(data)

# Vector to be used for the statistical methods
# Using the "HIGH" column of Helwett-Packard Stocks (HPQ)
data <- dplyr::filter(data, data$Stock_Symbol == "HPQ")
vec <- as.vector(data$High)

# 1. Mean
# Function to calculate the mean, given a vector as the function parameter
rushabh_mean <- function(x) {
    len <- length(x)
    sum <- 0
    for(i in 1:len) {
        sum <- sum + x[i]
    }
    ans <- sum/len
    return(ans)
}
# Mean of High column
mu <- round(rushabh_mean(vec), 4)
print(paste("Mean is :", mu))

# 2. Median
# Function to calculate the median, given a vector as the function parameter
rushabh_median <- function(x) {
    # Sorting the vector
    n <- length(x)
    x <- sort(x)

    if(n %% 2 == 0) {
        ans <- x[n/2]
        return(ans)
    }
    else {
        ans <- (x[(n-1)/2] + x[(n+1)/2])/2
        return(ans)
    }
}
# Median of High column
median <- round(rushabh_median(vec), 4)
print(paste("Median is :", median))

# 3. Mode
# Function to calculate the mode, given a vector as the function parameter
rushabh_mode <- function(x) {
    n <- length(x)
    mode <- 0
    max_count <- 0
    for(i in 1:n) {
        count <- 0
        for(j in 1:n) {
            if(x[i] == x[j]) {
                count <- count + 1
            }
        }
        if(count > max_count) {
            mode <- x[i]
            max_count <- count
        }
    }
    return(mode)
}
# Mode of High column
mode <- round(rushabh_mode(vec), 4)
print(paste("Mode is :", mode))

# 4. IQR
# Function to calculate the IQR, given a vector as the function parameter
rushabh_iqr <- function(x) {
    x <- sort(x)
    n <- length(x)

    if(n %% 2 == 0) {
        h <- n/2
        iqr <- rushabh_median(x[(h+1):n]) - rushabh_median(x[1:h])
        return(iqr)
    }
    else {
        h <- n %/% 2
        first_half <- x[1:h]
        second_half <- x[(h+2):n]
        iqr <- rushabh_median(second_half) - rushabh_median(first_half)
        return(iqr)
    }
}
# IQR of High column
iqr <- round(rushabh_iqr(vec), 4)
print(paste("Inter Quartile Range (IQR) is :",iqr))

# 5. Standard Deviation
# Function to calculate the SD, given a vector as the function parameter
rushabh_sd <- function(x) {
    mu <- rushabh_mean(x)
    n <- length(x)
    sum <- 0
    for(i in 1:n) {
        sum <- sum + (x[i] - mu)^2
    }

    sd <- sqrt(sum/(n-1))
    return(sd)
}
# SD of High column
sd <- round(rushabh_sd(vec), 4)
print(paste("Standard Deviation is :", sd))



# 6. Probability values on Empirical Rule
# The empirical rule states that
# Suppose you have a normal distribution with mean and standard deviation. Then, each of the following is true:
# 68% of the data will occur within one standard deviation of the mean.
# 95% of the data will occur within two standard deviations of the mean.
# 99.7% of the data will occur within three standard deviations of the mean.
print(paste0("68.3% of the data occurs in the range (", mu - sd, ", ", mu + sd, ")"))
print(paste0("95.4% of the data occurs in the range (", mu - 2*sd, ", ", mu + 2*sd,")"))
print(paste0("99.7% of the data occurs in the range (", mu - 3*sd, ", ", mu + 3*sd,")"))



# 7. Plot the Graph/Histogram/Normal Distribution and compare your functions return value with predefined functions in R for Mean, Median, IQR, and SD.
# Plotting the values
plot(vec, 
    type = "p", 
    main = "Plot of the 'High' Stock Prices of Helwett-Packard (HP)",
    xlab = "Price", 
    pch = 20, 
    col = "blue"
)
    
boxplot(vec, 
    main = "'High' Stock Prices of Helwett-Packard (HP)", 
    ylab = "Price", 
    col = "gray"
)

# Histogram with normal curve
hist(vec, probability = T)
curve(dnorm(x, mean = mu, sd= sd), add = T)

# Comparing my function values with R predefined functions
# Mean
print(paste("Mean calculated by user-defined function: ", mu))
print(paste("Mean calculated by predefined function: ", mean(vec)))
# Median
print(paste("Median calculated by user-defined function: ", median))
print(paste("Median calculated by predefined function: ", median(vec)))
# IQR
print(paste("IQR calculated by user-defined function: ", iqr))
print(paste("IQR calculated by predefined function: ", IQR(vec)))
# Standard Deviation
print(paste("SD calculated by user-defined function: ", sd))
print(paste("SD calculated by predefined function: ", sd(vec)))
# Mode
print(paste("Mode calculated by user-defined function: ", mode))
print(paste("Mode calculated by predefined function: ", mfv(vec)))



# 8. Formulate the Null Hypothesis and Alternative Hypothesis for your data set and prove it based on the p-value.
# Using t-Test for the hypothesis between the High Intraday Prices of "Toyota Motors" and "Johnson & Johnson"
# A t-test is a statistical test that is used to compare the means of two groups
# STEP 1 :
# Random sample of 100 rows will be taken from the population
# STEP 2 :
# Null Hypothesis
# HO : There is no significant difference between the High Intraday Prices of "Toyota Motors" and "Johnson & Johnson"
# Alternate Hypothesis
# Ha : There is significant difference between the High Intraday Prices of "Toyota Motors" and "Johnson & Johnson"
# STEP 3 :
# Significance Level : 5% (0.05)
# STEP 4 :
# Calculating the Test Statistic and Corresponding p-Value

# Importing the Dataset
data <- read.csv("https://raw.githubusercontent.com/rushabhkela/Data-Science-with-R/main/Part%201/StockData.csv")
tm <- data[data$Stock_Symbol == "TM", c(1,5)]
head(tm)
jnj <- data[data$Stock_Symbol == "JNJ", c(1,5)]
head(jnj)

# Applying the t-Test
result <- t.test(sample(tm$High,100), sample(jnj$High,100), var.equal = T)
print(result)

# Importing the library to plot t-Test
library(webr)
plot(result)

# STEP 5 :
# Conclusion
# As seen from the result of t.test
# p-value is very small = 1.513e-09 (might differ in every run of the code, as a random sample is being taken)
# Since the p-value is less than the significance level (0.05), null hypothesis is rejected and alternative hypothesis is accepted.
# Hence, Ha is accepted, there is a significant difference between "Toyota Motors" and "Johnson & Johnson" stocks with respect to their High Intraday Prices
# The High Intraday Prices of "Toyota Motors" are higher than that of "Johnson & Johnson".
print("Statistical Analysis and Hypothesis Formulation were performed on the dataset")