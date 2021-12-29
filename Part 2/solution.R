# META DATA :
# Author : Rushabh Kela
# Topic : Data Preprocessing
# Last Modified : 14-Sep-2021 15:45

# Importing the required libraries
library("dplyr")
library("utils")
library("stringr")
library("rvest")

# Reading the data
df <- read.csv('https://raw.githubusercontent.com/anthoniraj/datasets/main/data_cleaning/tweet.csv')
str(df)
head(df)

#### Part 1

# Removing NA columns (no values), by observation, last three columns have NA values
df <- select(df, 1:5)
head(df)

# Removing Misplaced Rows and Empty Rows
# Removing rows with NA values
df <- df[rowSums(is.na(df)) != ncol(df), ]

# Removing empty rows
df <- df[!apply(df == "", 1, all), ]

# Removing Rows with empty tweets
df <- filter(df, df$text != "")

# Check for misplaced columns
# Removing rows with values other than TRUE and FALSE
df <- filter(df, df$favorited %in% c(TRUE, FALSE))

# Keeping rows which have only valid date
df <- filter(df, grepl('^(0?[1-9]|[12][0-9]|3[01])[\\-](0?[1-9]|1[012])[\\-]\\d{4}',
df$created))
df <- filter(df, df$statusSource != "")

# Removing rows where retweetCount is not a number
df <- filter(df, grepl('^[0-9]+$', df$retweetCount))
head(df)

#### Part 2
df$retweetCount <- as.numeric(df$retweetCount)
head(df)

#### Part 3
df_subset <- filter(df, df$retweetCount > 1000)
head(df_subset)

#### Part 4
df[['created']] <- strptime(df[['created']], format = "%d-%m-%Y %H:%M")
head(df)

#### Part 5
usernameRows <- filter(df, grepl('@\\S+', df$text))
head(usernameRows)

#### Part 6
# Using RegEx to extract the usernames
df$usernames <- str_extract_all(df$text, "@[a-zA-Z0-9\\-\\_]+")
head(df)

#### Part 7
# Using rvest library to extract html from <a> </a> node in the statusSource column
# For loop is used to extract each html text one - by - one and read the content
for(i in 1:length(df$statusSource)) {
 html <- read_html(df$statusSource[i])
 content <- html_elements(html, "a")
 df$statusSource[i] <- html_text(content)
}
head(df)