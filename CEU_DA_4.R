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

hotels <- merge(hotels, gdp,  by = 'country') ## left join ... on ...

head(hotels)

## TODO compute the avg price of hotels per country and compare w/ GDP
temp <- hotels[, list(price_avg = mean(price_EUR), cnt = .N), by = country]
temp <- merge(temp, gdp[, c('country', 'gdp')], by = 'country')

ggplot(temp, aes(gdp, price_avg, size = cnt)) + geom_point() + geom_smooth(method = 'lm') 
ggplot(temp, aes(gdp, price_avg)) + geom_point(aes(size = cnt)) + geom_smooth(method = 'lm') ##size can be defined as part of the geom_point as well!

ggplot(temp, aes(gdp, price_avg)) + geom_text(aes(label = country))

## TODO throw out the outlier points (just based on avg price read from the chart)
ggplot(temp[price_avg < 150, ], aes(gdp, price_avg)) + geom_point(aes(size = cnt)) + geom_smooth(method = 'lm')

## geocoding
i < - 1
hotels[i]

for (i in 1:nrow(hotels)) {
  ##print(i)
  hotels[i, lon := geocode(...)]
  hotels[i, lat := geocode(...)]
}

install.packages('ggmap')
library(ggmap)

geocode('Budapest, Hungary') ##google api
geocode('Budapest, Hungary', source = 'dsk') ##data science toolkit

geocodes <- hotels[, .N, by = citycountry]
for (i in 1:nrow(geocodes)) {
  geocode <- geocode(geocodes[i, citycountry], source = 'dsk')
  geocodes[i, lon := geocode$lon]
  geocodes[i, lat := geocode$lat]
}
head(geocodes)

## TODO plot cities on the map with points (size = N)
?map_data
worldmap <- map_data('world')
str(worldmap)

ggplot() + 
  geom_polygon(data = worldmap, aes(x=long, y=lat, group = group)) +
  geom_point(data = geocodes, aes(lon, lat, size = N, color = 'red')) +
  coord_fixed(1.3)

## ggmap
europe <- get_map(location = 'Berlin', zoom = 4, maptype = 'terrain')
ggmap(europe) + geom_point(data = geocodes, aes(lon, lat, size = N/25, color = N))


## googleway
install.packages('googleway')
library(googleway)

##to be finished