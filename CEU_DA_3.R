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

##put readable lables on the categories
hotels[, pricecat := cut(price_EUR, 
                         breaks = c(0, 
                                    avg_price_per_city[1] - sd_price_per_city[1], 
                                    avg_price_per_city[1] + sd_price_per_city[1], 
                                    Inf), 
                         labels = c('below avg', 'avg', 'above avg'),
                         dig.lab = 8),
       by = city]
hotels[, .N, by = pricecat]

## TODO new categorical variable: city type (small, big), based on number of hotels
median_city_size <- median(hotels[, hotel_count := .N, by = city][, hotel_count])

median_city_size
hotels[, hotel_count := .N, by = city][order(hotel_count)]

hotels[, citytype := cut(hotel_count,
                          breaks = c(0, median_city_size, Inf),
                          labels = c('small', 'big')
                          )]
## same without specified breaks:
hotels[, citytype := cut(hotel_count,
                         breaks = 2,
                         labels = c('small', 'big')
)]

hotels[, .N, by = citytype]

## multiple summareis
hotels[, .N, by = list(pricecat, citytype)][order(pricecat, citytype)]

## TODO new column "P": percentage per citytpye
price_per_type <- hotels[, .N, by = list(pricecat, citytype)]
temp[, P:= round(N/sum(N) * 100,2), by = citytype][order(citytype, pricecat)]

## this works as well:
hotels[, .N, by = list(pricecat, citytype)][, P:= N/sum(N), by = citytype][order(citytype, pricecat)]


## multiple summaries
hotels[, list(price_avg = round(mean(price_EUR),2),
              price_max = round(max(price_EUR),2),
              price_min = round(min(price_EUR),2)),
       by = city]


## mean of price, rating, stars
hotels[, list(price = round(mean(price_EUR, na.rm = TRUE), 2),
              rating = round(mean(rating, na.rm = TRUE), 2),
              stars = round(mean(stars, na.rm = TRUE), 2)),
       by = city]

## simplified code with lapply for the above:
hotels[, 
       lapply(.SD, mean, na.rm = TRUE), 
       by = city, 
       .SDcols = c('price_EUR', 'rating', 'stars')]
?lapply


## ===========================================================

hotels <- fread('http://bit.ly/CEU-R-hotels-2017-v2') ##fread - fast read, part of dt package

?write.csv
?fwrite ## fast writing cs


library(ggplot2)
?ggplot

ggplot(data = hotels, mapping = aes(x = pricecat))
ggplot(data = hotels, mapping = aes(x = pricecat)) + geom_bar()
ggplot(data = hotels, mapping = aes(x = pricecat)) + geom_bar() + theme_bw()

p <- ggplot(data = hotels, mapping = aes(x = pricecat)) + geom_bar()
str(p)
