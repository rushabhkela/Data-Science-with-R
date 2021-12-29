# META - DATA
# Author : Rushabh Kela
# Topic : Modelling, Evaluation, and Visualisation
# Last Modified : 01-Dec-2021, 15:12

# TASK 1 : Building the dataset
# STOCK
# Name : Hindustan Unilever Limited
# Symbol : HINDUNILVR
# Live NSE Market Prices fetched using jugaad-data Python Library.
# DATASET COLUMNS INFORMATION
# Timestamp : Time at which the data is fetched (YYYY-MM-DD HH:MM:SS format)
# Price : The price at which the stock is currently trading on at a particular point of time
# Change_Price : Change in trading price
# Change_Percent : Percentage change in trading price
# Prev_Close : Prior day's final price of a security when the market officially closes for the day
# Open : The opening price is the price at which a security first trades upon the opening of an exchange on a trading day
# VWAP : The volume-weighted average price (VWAP) is a trading benchmark used by traders that gives the average price a security has traded at throughout the day
# Intraday_High : The high is the highest price at which a stock traded during a period.
# Intraday_Low : The lowest price at which a stock trades on a given trading day

# TASK 2 : Preprocessing and applying the model
# Importing the libraries
library(stats)
library(utils)
library(graphics)
library(base)
library(dplyr)
library(lubridate)
library(plotly)
library(caTools)

# Reading the data
data <- read.csv("https://raw.githubusercontent.com/anthoniraj/dsr_datasets_final/main/19BDS0055.csv")
head(data)

# The stock market was closed on 19th November, and data fetched from the website was not updated
# Hence, dropping the redundant data
data <- dplyr::filter(data, !grepl("^2021-11-19", data$Date))

# Renaming the columns
names(data) <- c("Timestamp", "Price", "Change_Price", "Change_Percent", "Prev_Close", "Open", "VWAP", "Intraday_Low", "Intraday_High")

# Converting Date to UNIX
# Setting Time Zone
data$Timestamp <- with_tz(data$Timestamp, tzone = "Asia/Kolkata")
data$Timestamp <- as.numeric(as.POSIXct(data$Timestamp))
# Formatting Change Price and Change Percentage Columns
data$Change_Percent <- as.numeric(data$Change_Percent)
data$Change_Price <- as.numeric(data$Change_Price)
head(data)

# Identifying Target and Feature Variables
# Target Variable : Price
# Feature Variable : Timestamp, VWAP, Intraday_High, Intraday_Low
# Applying the MULTIVARIATE LINEAR REGRESSION MODEL
set.seed(100)
split <- sample.split(data, SplitRatio = 0.8)
trainingStock <- subset(data, split == TRUE)
testStock <- subset(data, split == FALSE)

MVLR_model <- lm(Price ~ Timestamp+VWAP+Intraday_High+Intraday_Low, data=trainingStock)

# Predicting the values of test dataset
pricePrediction <- predict(MVLR_model, testStock)

# Calculating the accuracy
priceActual <- data.frame(cbind(Actual_Price=testStock$Price,
Predicted_Price=pricePrediction))
accuracy <- cor(priceActual)
print("Correlation Matrix: ")
accuracy

# Model Evaluation
original <- testStock$Price
predicted <- pricePrediction
x=1:length(original)
plot(x, original, pch=19, col="blue")
lines(x, predicted, col="red")
legend("topleft", 
    legend = c("y-original", "y-predicted"), 
    col = c("blue", "red"), 
    pch = c(19,NA), 
    lty = c(NA,1), 
    cex = 0.7
)

diff <- original-predicted
mse <- mean((diff)^2)
mae <- mean(abs(diff))
rmse <- sqrt(mse)
R2 <- 1-(sum((diff)^2)/sum((original-mean(original))^2))

print(paste("MAE (Mean absolute error) is :", mae))
print(paste("MSE (Mean Squared Error) is :", mse))
print(paste("RMSE (Root Mean Squared Error) is :", rmse))
print(paste("R-squared (Coefficient of determination) is :", R2))

# Visualisation
# Plotly Library of R is used for the visualisations to be interactive.
# Converting the POSIX timestamp to Date-Time format for better visualisation (XAxis Labels)
data$Timestamp <- as.POSIXct(data$Timestamp, origin="1970-01-01")

# Boxplot
# The VWAP (volume - weighted average price is visualised using a boxplot)
x <- as.Date(data$Timestamp)
y <- data$VWAP
boxplot(y ~ x, xlab = "Date", ylab = "VWAP Price", main = "Boxplot of VWAP Prices" )

# Candlestick Chart
# It is mainly used in financial prices visualisation for the stock market intraday prices
# It shows the four price points (Open, High, Low, Close) for the given stock throughout the period of time specified

candle <- data %>% plot_ly(x = ~as.Date(data$Timestamp),
    type = 'candlestick',
    open = ~Open,
    close = ~Prev_Close,
    high = ~Intraday_High,
    low = ~Intraday_Low
)
candle <- candle %>%
    layout(title = "Candlestick chart for HINDUNILVR stock",
    xaxis = list(title = "Date"),
    yaxis = list(title = "Price (in INR)")
)
candle

# Time Series Plot
# For the Time Series Plot, X-Axis will have represent the Timestamp and Y-Axis the corresponding Price at that time
# To avoid large number of labels on the X-Axis (of each timestamp), I have grouped the labels according to the Dates
xgroups <- data %>%
    group_by(as.Date(Timestamp)) %>%
    filter(row_number() == 1)

xvals <- xgroups$Timestamp
xlabels <- format(as.Date(xgroups$Timestamp), "%b %d")
timeSeries <- data %>%
 plot_ly(x = ~Timestamp, y = ~Price, type='scatter', mode = 'lines') %>%
 layout(
        title = "Time Series Chart for HINDUNILVR stock",
        xaxis = list(
        title = "Date",
        type = "category",
        ticktext = xlabels,
        tickvals = xvals,
        tickangle = 0
    ),
    yaxis = list (
        title = "Price"
    )
)
timeSeries

print("Hence, the multivariate linear regression model was implemented and evaluated.")