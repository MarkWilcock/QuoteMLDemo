# QuoteMLDemo

This is short tutorial R code to demo a simple machine learning example using R.

## Assets

- R Script
- Sample CSV dataset and "presentable" Excel version (highlighted and formatted so easier for audience to understand)


## Cloud assets

- Equivalent Azure ML Model

## Background

The scenario is to classify quotes into buy or sell intention based on details of the counterparty and the product for which the quote is being obtained.

Banks are asked by a counterparty to quote both the sell and buy price of a financial  instrument, such as a bond or a currency.  This is often called the bid-offer price.  An example may be 102.46 (bid) to 102.50 (offer) meaning that the bank is prepared to buy a given amount of the instrument at 102.46 and to sell at the slightly higher price of 102.50.  The counterparty can then state their intent whether to buy or sell to the bank - or neither.

The purpose of the ML model is to predict whether quote is likely to result in a buy order or sell order i.e.the intent of the counterparty when requesting the quote based on some details about the counterparty, the bond and the time of day and the day (since the business suspects that counterparties may have different behaviour at the end of the week or month).

This is a two class (binary) classifier. One attractive feature is that the split of the classes is even - overall the bank expects  RFQs to crystallise into approximately 50% buy, 50% sell order. This is unlike many financial use cases e.g. fraud where the classes are very unbalanced.


### Work done

- Built R Script, as R Markdown, to load sample dataset, split into train & test datasets, apply a decision tree and show some accuracy stats, apply  logistic model and show a ROC Curve.
- Built equivalent Azure ML model

### Work to do

- Create an R notebook version of this Rmd (markdown) script - may be better to demo
- Implement this with Microsoft R Server and RevoScale (rx) package as an initial step in scaling up.
- Implement using sparklyr and dplyr
- Scale up the demo to a much large number of rows in a Azure SQL database
- Scale up the demo to a much large number of rows in a Spark environment




