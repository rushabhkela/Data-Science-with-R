# Importing the libraries
library(jsonlite)
library(httr)
library(dplyr)

# API key for information retrieval from alphavantage.co
apiKey <- 

# Stock Symbols - whose data is being fetched
stocks = c( "XOM", "AAPL", "MSFT", "JPM", "HPQ", "GS", "AZN", "GE", "BAC","TM",
            "PFE", "JNJ", "INTC", "IBM", "CSCO", "GOOG", "NOK", "BCS", "DELL", "AXP",
            "ORCL", "EBAY", "MCD", "ADBE", "WIT","AMZN"
            )

# Corresponding stock names
stocknames <- c("Exxon Mobil Corporation",
                "Apple Computer, Inc.",
                "Microsoft Corporation",
                "J.P. Morgan Chase & Co.",
                "Hewlett-Packard Company",
                "Goldman Sachs Group, Inc.",
                "Astrazeneca Plc.",
                "General Electric Company",
                "Bank of America Corporation",
                "Toyota Motor Corporation",
                "Pfizer Inc.",
                "Johnson & Johnson",
                "Intel Corporation",
                "International Business Machines Corporation",
                "Cisco Systems Inc", 
                "Google Inc.",
                "Nokia Corporation",
                "Barclays Plc",
                "Dell Inc.",
                "American Express Company",
                "Oracle Corporation",
                "eBay Inc.",
                "McDonald's Corporation",
                "Adobe Systems",
                "Wipro Limited",
                "Amazon.com Inc."
                )

# Getting previous day date to fetch intraday data
todayDate <- Sys.Date() - 1
# Getting the data
i = 1;

for (stock in stocks) {
    # URL from where data is returned in JSON format
    url = paste("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=", stock, "&interval=15min&outputsize=full&apikey=", apiKey, sep = "")
    content <- fromJSON(url)
    
    ## Filtering the data
    data <- content$`Time Series (15min)`

    # Arranging into rows based on timestamp (here I have taken every 15 min interval)
    data <- bind_rows(data, .id = 'timestamp')
    
    # Discard the little historical data returned, and fetch the latest data
    data <- filter(data, grepl(todayDate, data$timestamp))
    
    # Adding a column to display the stock name, for better understanding of the dataset
    data$stockname <- stocknames[i]
    data <- cbind(stock, data)
    
    # Rearranging the columns
    data <- data[, c(1, 8, 2, 3, 4, 5, 6, 7)]
    
    # Naming the columns
    colnames(data) <- c("Stock Symbol", "Stock Name", "Timestamp", "Open", "High", "Low", "Close", "Volume")
    
    # Used on first run only, as column names must be added only once
    write.table(data, file="Alphavantage_Stocks.csv", sep=",", append = TRUE, col.names = ifelse(stock=="XOM", TRUE, FALSE), row.names = FALSE)
 
    # Used from second run
    # write.table(data, file="Alphavantage_Stocks.csv", sep=",", append = TRUE, col.names = FALSE, row.names = FALSE)
    
    i <- i+1

    # Alphavantage API provides only 5 API calls per minute in the free tier
    # This Sys.sleep(15) pauses the execution of the program by 15 seconds before running the next iteration of the loop
    Sys.sleep(15)
}

# Data is saved in Alphavantage_Stocks.csv file