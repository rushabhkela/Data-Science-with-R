# Obtaining the Data

## Question 

<b>Obtain data from REST API calls / Web Scrapping over a period of time and generate a dataset.</b>

<details>
  <summary><b>View Solution</b></summary>
  

<h4>Description: </h4>

I have taken 26 stocks and fetched their `INTRADAY` data from `ALPHAVANTAGE API`. The `ALPHAVANTAGE API` returns the `INTRADAY` data of the previous trading day. Data is retrieved through `API` calls in `JSON` format and stored in StockData.csv file.

<br>

<h4>Data Source Details: </h4>
Alpha Vantage provides enterprise-grade financial market data through a set of powerful and developer-friendly APIs. From traditional asset classes (e.g., stocks and ETFs) to forex and cryptocurrencies, from fundamental data to technical indicators, Alpha Vantage is your one-stop-shop for global market data delivered through cloud-based APIs.
<ul>
<li> <a href="https://www.alphavantage.co/">Website</a> </li>
<li> <a href="https://www.alphavantage.co/documentation/">Documentation</a> <l/i>
</ul>
<br>
<h4>Data Retrieval Process:</h4>

<ol>

<li> 

  The required libraries such as `jsonlite` for parsing JSON data, `httr` to facilitate calls to APIs and `dplyr` package used to manipulate and filter data are loaded. 
</li>
<li>

To get information from `ALPHAVANTAGE API`, an API key is required, which is created on the official website and stored in a variable in the `R Script`.</li>
<li>

26 stocks are declared whose intraday data will be fetched from the API. For better understanding, another vector containing the stock names is declared to add these values to the dataset in a separate column.</li>
<li>

Data is fetched from the API.
<br>
   API Parameters :
   <ul type="disc">
   <li> 
   
   `function` : Required Parameter. 
   <br>
      In this case, `function=TIME_SERIES_INTRADAY`  </li>
   <li> 
   
   `symbol` : Required Parameter.
   <br>
      The name of the equity of your choice, example : `symbol=IBM`  </li>
   <li> 
   
   `interval` : Required Parameter.
   <br>
      Time interval between two consecutive data points in the time series.
      The following values are supported: 1min, 5min, 15min, 30min, 60min
      In my dataset, I have taken it to be 15 min.  </li>
   <li> 
   
   `outputsize=full`, this returns the full – length intraday time series.
   <li> 
   
   `apikey` : Required Parameter.  </li>
   </ul>
 </li>
  
<li>The data is returned in JSON format. The data is then filtered and arranged accordingly to present in a clear understandable format. </li>
<li>The data is written into a .csv file using the write.table function to the StockData.csv file. </li>
<li>Before running the next iteration of the for loop, the system is paused for 15 seconds. This is because `ALPHAVANTAGE` allows only 5 API calls per minute. If the program is made to run continuously without any halt, it may exceed the allowed number of requests and terminate with an error. </li>

</ol>

<h4>R Script:</h4>
<a href="https://github.com/rushabhkela/Data-Science-with-R/blob/main/Part%201/solution.R"><b>Code</b></a>


<h4>Dataset Details:</h4>
The dataset contains 27483 rows and 8 columns (as of 21-Sept-2021).
The stock name / symbol and its corresponding timestamp make up the unique identifier key for any row in the dataset.
<br>
There are 8 columns :
<ul>
<li><b>Stock symbol : </b>
 A stock symbol is a unique series of letters assigned to a
 security for trading purposes. 
 
 Example : `AAPL` for Apple Inc., `GOOG` for
 Google etc.
 
 </li>
 
<li><b>Stock Name : </b>
The name of the stock corresponding to the stock symbol.
</li>


<li><b>Timestamp : </b>
This is the time and date corresponding to the entry of the stocks and their prices.
</li>

<li><b>Open : </b> Open denotes the price at which the stock trading began in a given
time period. 
</li>
<li><b> High : </b>The high is the highest price at which a stock traded during a period.
</li>

<li><b> Low : </b>Low refers to the minimum price of the stock in the given time period. </li>
<li><b> Close : </b>Close is the price at which the stock trading ended in a given time period. It represents the last buy-sell order executed between two traders.
</li>
<li><b> Volume : </b>
Volume is the total number of shares traded in a security over a
period. Every time buyers and sellers exchange shares, the amount gets
added to the period’s total volume. Studying volume patterns are an
essential aspect of technical analysis because it can show the significance
of a stock’s price movement.

</li>
</ul>

<h4>Sample Dataset:</h4>

<a href="https://github.com/rushabhkela/Data-Science-with-R/blob/main/Part%201/StockData.csv"><b>Dataset</b></a>


</details>
