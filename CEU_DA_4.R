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

##fix the content of city
hotels[, city := strsplit(city, ', ')[[1]][1], by = city]

## Count the number of hotels in Hungary
hotels[country == 'Hungary', .N]

## Count the number of cities with hotels in Germany
nrow(hotels[country == 'Germany', .N, by = city])

## count the avg number of hotels per city
hotels[, .N, by = city][, mean(N)]

## count the avg number of hotels per city per country
hotels[, .N, by = c('city', 'country')][, mean(N), by = country]

## compute the percentage of national hotels per city
temp <- hotels[, .N, by = c('city', 'country')]
temp[, N_cntry := sum(N), by = country]
temp[, N / N_cntry, by = city]
