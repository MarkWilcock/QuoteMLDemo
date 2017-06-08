# useful.R


# snippets to run ReveScale models and to save as consolidate CSV

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
