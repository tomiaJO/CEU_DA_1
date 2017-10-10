library(data.table)
hotels <- fread('http://bit.ly/CEU-R-hotels-2017-v2')
str(hotels)

hotels[, .N, by = city]


x <- 'Budapest, Hungary'
strsplit(x, ', ')
str(strsplit(x, ', '))

strsplit(x, ', ')[[1]][2] ##outcome is a list -- double brackets

str(list(a = 1:3))
list(a = 1:3)[[1]][2] ## filtering for 2 in the list

hotels[, country := strsplit(city, ', ')[[1]][2], by = city] ##by = city --> make sure it's run for every bucket, once
##use of by depends on vectorization of the function! but helps the performance anyway..

##same thing with regex
sub('.*, ', '', x)

##TODO copy the content of city to citycountry
hotels[, citycountry := city, by = city]
setnames[hotels, 'city', 'citycountry'] ## other aproach for the same thing, does not copy the column just renames it

## TODO fix the content of city
hotels[, city := strsplit(city, ', ')[[1]][1], by = city]

## TODO ount the number of hotels in Hungary
hotels[country == 'Hungary', .N]

## TODO Count the number of cities with hotels in Germany
nrow(hotels[country == 'Germany', .N, by = city])
hotels[country == 'Germany', length(unique(city))] ## unique ~~ DISTINCT in SQL

## TODO count the avg number of hotels per city
hotels[, .N, by = city][, mean(N)]

## TODO count the avg number of hotels per city per country
hotels[, .N, by = c('city', 'country')][, mean(N), by = country]

## TODO compute the percentage of national hotels per city
temp <- hotels[, .N, by = c('city', 'country')]
temp[, N_cntry := sum(N), by = country]
temp[, N / N_cntry, by = city]

## TODO draw histogram prices of hotels in Hungary with rating > 4.5
library(ggplot2)

ggplot(hotels[country == 'Hungary' & rating > 4.5, ], aes(price_EUR)) + 
  geom_histogram(binwidth = 50) + 
  xlab('') + ylab('') +
  ggtitle('Number of hotels', subtitle = 'Good hotels in Hungary') +
  scale_x_continuous(labels = dollar_format(suffix = 'EUR', prefix = ''))

ggplot(hotels[country == 'Hungary' & rating > 4.5, ], aes(factor(1), price_EUR)) + geom_boxplot()

?dollar_format

##### add  GDP

install.packages('XML')
library(XML)

gdp <- readHTMLTable(readLines('http://bit.ly/CEU-R-gdp'), which = 3)
head(gdp)

gdp <- data.table(gdp)

gdp[, country := iconv(`Country/Territory`, to = 'ASCII', sub = '')] ##remove special characters

gdp[,  gdp := sub(',', '', `Int$`)]
gdp[, gdp:= as.numeric(gdp)]

countries <- hotels[, unique(country)]
countries %in% gdp$country ##check which countries can be found in our list

merge(hotels, gdp,  by = 'country')

head(hotels)
