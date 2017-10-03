df <- read.csv('http://bit.ly/CEU-R-hotels-2017')
library(data.table)
hotels <- data.table(df)

names(hotels)

## TODO the required budget in EUR to try all hotels for a night
hotels$price_EUR <- hotels$price_HUF / 312.11

hotels[, sum(price_EUR)]
str(hotels$downloaded)
