#  *Prep: start HDI markspark.  Install sparklyr.  Build Hive table.  Show with Hue*
  
# This is an implementation using sparklyr  
# The technical scenario: the data is now on a Azure hadoop HDInsight RServer (Spark) cluster.  This is run from RStudio Server on the edge node.
# See the CRAN implementation for all project background details.


#options(repos = "https://mran.microsoft.com/snapshot/2017-05-01") # very necessary
#install.packages("sparklyr")

library(sparklyr)
library(dplyr)

# 0. Connect to Spark and set up Spark Context

cc <- rxSparkConnect(reset = TRUE, interop = "sparklyr")
sc <- rxGetSparklyrConnection(cc)

# 1. Ingest

#The data must be in a Hive table for dplyr to operate on it a a Spark  object.
#*Show the data in the hive table wuth Hue*
  
hdfsFS <- RxHdfsFileSystem()

quote_data <- RxTextData("/sample-data/quotedata.csv", fileSystem = hdfsFS)
quote_data_hive <- RxHiveData(table="QuoteDataTable")
rxDataStep(inData = quote_data, outFile = quote_data_hive, overwrite = TRUE) 

src_tbls(sc) # show all Hive tables


# create a dplyr tibble pointing to the Spark Hive table
tbl_cache(sc, "QuoteDataTable")
quote_tbl <- tbl(sc, "QuoteDataTable")

print(class(quote_tbl))
quote_tbl

# 2. Feature Engineering

quote_tbl2 <- quote_tbl %>%
  select(-TradeKey) %>% 
  mutate(BuySellFlag = ifelse(BuySell == "Buy", 1, 0))

quote_tbl2

# 3. Split into training and test datasets

quote_tbl3 <- 
  quote_tbl2 %>% 
  sdf_partition(train = 0.7, test = 0.3, seed = 1234)

quote_tbl3

# 4a. Model and predict - linear model.

lin_mod <- quote_tbl3$train %>% ml_linear_regression(BuySellFlag ~ TimeOfDay + IsEndOfWeek + IsEndOfMonth + BondCountry + BondTenor + CounterpartyCountry +  CounterpartySector)
summary(lin_mod)

# to do: predict !
#rxSparkDisconnect(cc)

