df <- read.csv('http://bit.ly/CEU-R-hotels-2017')
library(data.table)
hotels <- data.table(df)

names(hotels)

## TODO the required budget in EUR to try all hotels for a night

hotels$price_EUR <- hotels$price_HUF / 310 #data.frame way (Creates a vector and add it to your df)
hotels[, price_EUR := price_HUF / 310] #data.table way (Creates the object inside the dt). More memory efficient!!
hotels[, sum(price_EUR)]

##TODO categorize price_EUR into 3 brackets

?cut
hotels[, pricecat := cut(price_EUR, breaks = 3, dig.lab = 8)] ##dig.lab: number of significant digits displayed
head(hotels)
str(hotels$pricecat)

hotels[, .N, by = pricecat]

## TODO same with equal breakpoints
quantile(hotels$price_EUR, 0.33)

hotels[, pricecat := cut(price_EUR, 
                         breaks = c(0, quantile(hotels$price_EUR, 1/3), quantile(hotels$price_EUR, 2/3), Inf), 
                         dig.lab = 8)]


hotels[, .N, by = pricecat][order(pricecat)]


##TODO mean, sd
avg_price <- hotels[, mean(price_EUR)]
sd_price <- hotels[, sd(price_EUR)]

hotels[, pricecat := cut(price_EUR, 
                         breaks = c(0, avg_price - sd_price, avg_price + sd_price, Inf), 
                         dig.lab = 8)]

hotels[, .N, by = pricecat][order(pricecat)] ##results are skewed

## TODO avg_price per city, and use this to decide if a hotel is cheap or not

hotels[, avg_price_per_city := mean(price_EUR), by = city]
hotels[, sd_price_per_city := sd(price_EUR), by = city]
#hotels[, cheap_flag := (price_EUR <= avg_price_per_city)]

##TODO pricecat using the above

## problem to solve - avgs are now not unique numbers, but vectors
## "Error in cut.default(price_EUR, breaks = c(0, avg_price_per_city - sd_price_per_city,  : 
## 'breaks' are not unique"
hotels[, pricecat := cut(price_EUR, 
                         breaks = c(0, 
                                    avg_price_per_city[1] - sd_price_per_city[1], 
                                    avg_price_per_city[1] + sd_price_per_city[1], 
                                    Inf), 
                         dig.lab = 8),
       by = city]


