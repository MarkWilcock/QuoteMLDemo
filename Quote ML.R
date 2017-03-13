# Quote ML.R

# Spike to test using ML algorithms againsa simulated financial trading dataset
# Use case: 
#  Bank receives quotes for certain sovereign bonds.
#  Bank has to quote both bid and offer prces but does not know whether counterparty is wanting to buy or sell until they have received quotes
#  Purpose of the ML model is to predict whether quote is likely to result in a buy order or sell order i.e.the intent of the counterparty when requesting the quote
#  This is a two class classifier
#  One attractive feature is that the split of the classes is even - overall bank expects  request for quote to crystallise into approximately 50% buy, 50% sell order
#  This is unlike many financial use cases e.g. fraud where the claases are very unbalanced

if (!("readxl" %in%  rownames(installed.packages()))) install.packages("readxl")
if (!("dplyr" %in%  rownames(installed.packages()))) install.packages("dplyr")
if (!("rpart" %in%  rownames(installed.packages()))) install.packages("rpart")
if (!("rpart.plot" %in%  rownames(installed.packages()))) install.packages("rpart.plot")
if (!("RColorBrewer" %in%  rownames(installed.packages()))) install.packages("RColorBrewer")
if (!("ROCR" %in%  rownames(installed.packages()))) install.packages("ROCR")
if (!("rattle" %in%  rownames(installed.packages()))) install.packages("rattle")

library(readxl)
library(dplyr)
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(ROCR)
library(rattle)

setwd("C:/Users/markw/Zomalex Ltd/OneDrive - Zomalex Ltd/Demos/Quote ML Demo")
getwd()

df <- read.csv(file = "Bond Quote Data.csv", header = TRUE)

str(df)

# Split data into 70% training and 30% test 
set.seed(1234)
# create a new column - each row takes a uniform random variable between 0 and 1
df <- mutate(df, tempval = runif(nrow(df)))
df.train <- filter(df, tempval <= 0.7) %>% select(-tempval)
df.test <- filter(df, tempval > 0.7) %>% select(-tempval)

decision.tree.model <-
  rpart(BuySell ~ TimeOfDay + IsEndOfWeek + IsEndOfMonth +
          CounterpartyCountry + CounterpartySector + 
          + BondCountry + BondTenor,
        data = df.train,
        method = "class")

#fancyRpartPlot(decision.tree.model, cex = 0.6)

# let's use the decision tree model to predict
(decision.tree.prediction <-
    predict(decision.tree.model, df.test, type = "class"))

df.test <- mutate(df.test, BuySell.dtree = decision.tree.prediction)


# count of true positives  - can go further to vcalculate  accuracy  etc manually
count.tp <- nrow(filter(df.test, BuySell == 'Buy' & BuySell.dtree == 'Buy'))
count.fp <- nrow(filter(df.test, BuySell == 'Sell' & BuySell.dtree == 'Buy'))
count.fn <- nrow(filter(df.test, BuySell == 'Buy' & BuySell.dtree == 'Sell'))
count.tn <- nrow(filter(df.test, BuySell == 'Sell' & BuySell.dtree == 'Sell'))
count.all <- nrow(df.test)

(accuracy <- (count.tp + count.tn) / count.all)

#precision - what % of items identified were actually in the class
precision = count.tp / (count.tp + count.fp)

#recall aka sensitivity -  what % of items in the class were identified by the classifier
recall = count.tp / (count.tp + count.fn)

specificity = count.tn / (count.tn + count.fp)



logit.model <-
  glm(BuySell ~ TimeOfDay + IsEndOfWeek + IsEndOfMonth + 
        BondCountry + BondTenor + 
        CounterpartyCountry +  CounterpartySector,
      data= df.train,
      family = binomial(link='logit'))

logit.prediction <- predict (logit.model, df.test, type='response')

df.test <- mutate(df.test, BuySell.logit = ifelse(logit.prediction <= .5, 'Buy', 'Sell'))

# count of true positives  - can go further to vcalculate  accuracy  etc manually
count.tp.logit <- nrow(filter(df.test,  BuySell=='Buy' & BuySell.logit=='Buy'))
count.fp.logit <- nrow(filter(df.test,  BuySell=='Sell' & BuySell.logit=='Buy'))
count.fn.logit <- nrow(filter(df.test,  BuySell=='Buy' & BuySell.logit=='Sell'))
count.tn.logit <- nrow(filter(df.test,  BuySell=='Sell' & BuySell.logit=='Sell'))

(accuracy.logit <- (count.tp.logit + count.tn.logit) / count.all)

pred <- prediction(logit.prediction, df.test$BuySell)

perf <- performance(pred, measure="tpr", x.measure = "fpr")

options(repr.plot.width = 5, repr.plot.height = 3)
plot(perf, col = rainbow(10), main = "Model performance")

### End of demo


# data_xls <- "Quote Sample Data.xlsx"
# df.quote <- read_excel(data_xls, sheet = "Bond Quote")
# df.bond <- read_excel(data_xls, sheet = "Bond")
# df.counterparty <- read_excel(data_xls, sheet = "Counterparty")
# df.date <- read_excel(data_xls, sheet = "Date")
# 
# df.quote <- df.quote %>%
#   select(TradeKey, BondKey, CounterpartyKey, TradeDate, TimeOfDay, BuySell) %>%
#   mutate(TradeDate = as.Date(TradeDate),
#          TimeOfDay = factor(TimeOfDay,, levels = c("AM", "PM")),
#          BuySell = factor(BuySell, levels = c("Buy", "Sell")))
# 
# str(df.quote)
# 
# df.bond <- df.bond %>%
#   select(BondKey, BondCountry, BondTenor) %>%
#   mutate(BondCountry = as.factor(BondCountry), BondTenor = as.factor(BondTenor))
# 
# head(df.bond)
# 
# df.counterparty <- df.counterparty %>%
#   select(CounterpartyKey, CounterpartyCountry, CounterpartySector) %>%
#   mutate(CounterpartyCountry = as.factor(CounterpartyCountry), CounterpartySector = as.factor(CounterpartySector))
# 
# df.date <- df.date %>%
#   mutate(TradeDate = as.Date(TradeDate), IsEndOfWeek = as.factor(IsEndOfWeek), IsEndOfMonth = as.factor(IsEndOfMonth))
# 
# 
# df <- inner_join(df.quote, df.bond)
# df <- inner_join(df, df.counterparty)
# df <- inner_join(df, df.date)
# df <- select(df, - BondKey, - CounterpartyKey)
# 
# write.csv(df, file = "Bond Quote Data.csv", append = FALSE)


# Let's try a MRS model
## Note: this currently causes R error- must be  improperly constructed in some way
# rx.decision.tree.model <- rxDTree(BuySell ~ TimeOfDay + BondCountry + BondTenor + CounterpartyCountry + CounterpartyCountry + IsEndOfWeek + IsEndOfMonth,
#     data = df.train)
# 
# rx.lin.model <- rxLinMod(BuySell ~ TimeOfDay + BondCountry + BondTenor + CounterpartyCountry + CounterpartyCountry + IsEndOfWeek + IsEndOfMonth, data = df.train)
# str(df.train)


# head(df)
# table(df$BondTenor, df$BuySell)
# 
# table(df$BuySell)
# table(df$BondCountry, df$BuySell)
# prop.table(table(df$BondCountry, df$BuySell), margin = 1)
# 
# prop.table(table(df$CounterpartyCountry, df$BuySell))
